//
//  ViewController.m
//  Demo
//
//  Created by Aniket Jain on 16/05/17.
//  Copyright © 2017 Aniket Jain. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"
#import <Speech/Speech.h>

#define ADD_SearchIcon \
UIImage *searchImage = [UIImage imageNamed:@"search"]; \
UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom]; \
[searchButton setFrame:CGRectMake(0.0, 0.0, searchImage.size.width + 20, 44)]; \
[searchButton setImage:searchImage forState:UIControlStateNormal]; \
SEL searchSelector = NSSelectorFromString(@"showSearch");\
if ([self respondsToSelector:searchSelector]) { \
[searchButton addTarget:self action:searchSelector forControlEvents:UIControlEventTouchUpInside]; \
} \
UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithCustomView:searchButton]; \
\
[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:search, nil]];


@interface ViewController ()<SFSpeechRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (strong, nonatomic) SFSpeechRecognizer *speechRecognizer;
@property (strong, nonatomic) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (strong, nonatomic) SFSpeechRecognitionTask *recognitionTask;
@property (strong, nonatomic) AVAudioEngine *audioEngine;
// Locale Settings can be custommized for speech recognition supporting different languages
@property (strong, nonatomic) NSLocale *defaultLocale;

@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated
{
    ADD_SearchIcon
}
- (void)showSearch {
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSMutableArray *newViewControllers = [[NSMutableArray alloc] init];
    
    SearchViewController *searchViewController;
    for (UIViewController *viewController in viewControllers) {
        if ([viewController isKindOfClass:[SearchViewController class]]) {
            searchViewController = (SearchViewController *)viewController;
        }else{
            [newViewControllers addObject:viewController];
        }
    }
    
    if (searchViewController) {
        [newViewControllers addObject:searchViewController];
        [self.navigationController setViewControllers:newViewControllers animated:true];
    }else{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Search" bundle: nil];
        SearchViewController *destinationViewController = (SearchViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"SVC"];
        [self.navigationController pushViewController:destinationViewController animated:YES];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //demo
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [leftDrawerButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    self.defaultLocale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    [self prepareSpeechRecognizerWithLocale:self.defaultLocale];
    
    
}

- (void)prepareSpeechRecognizerWithLocale:(NSLocale *)locale {
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    self.speechRecognizer.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized: {
                    weakSelf.recordBtn.enabled = YES;
                    break;
                }
                case SFSpeechRecognizerAuthorizationStatusDenied: {
                    weakSelf.recordBtn.enabled = NO;
                    [weakSelf.recordBtn setTitle:@"User denied access to speech recognition" forState:UIControlStateDisabled];
                    break;
                }
                case SFSpeechRecognizerAuthorizationStatusRestricted: {
                    weakSelf.recordBtn.enabled = NO;
                    [weakSelf.recordBtn setTitle:@"Speech recognition restricted on this device" forState:UIControlStateDisabled];
                    break;
                }
                case SFSpeechRecognizerAuthorizationStatusNotDetermined: {
                    weakSelf.recordBtn.enabled = NO;
                    [weakSelf.recordBtn setTitle:@"Speech recognition not yet authorized" forState:UIControlStateDisabled];
                    break;
                }
            }
        });
    }];
}
- (void)startRecording {
    
    // Cancel the previous task if it's running.
    if (self.recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
    [audioSession setActive:YES error:nil];
    
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
    NSAssert(self.audioEngine.inputNode, @"Audio engine has no input node");
    NSAssert(self.recognitionRequest, @"Unable to created a SFSpeechAudioBufferRecognitionRequest object");
    
    // Configure request so that results are returned before audio recording is finished
    self.recognitionRequest.shouldReportPartialResults = YES;
    
    // A recognition task represents a speech recognition session.
    // We keep a reference to the task so that it can be cancelled.
    __weak typeof(self) weakSelf = self;
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BOOL isFinal = NO;
            
            if (result) {
                weakSelf.textView.text = result.bestTranscription.formattedString;
                isFinal = result.isFinal;
            }
            if (error || isFinal) {
                
                [self.audioEngine stop];
                [self.audioEngine.inputNode removeTapOnBus:0];
                
                weakSelf.recognitionRequest = nil;
                weakSelf.recognitionTask = nil;
                
                weakSelf.recordBtn.enabled = YES;
                [weakSelf.recordBtn setTitle:@"Start Recording" forState:UIControlStateNormal];
            }
            
        });
    }];
    
    AVAudioFormat *recordingFormat = [self.audioEngine.inputNode outputFormatForBus:0];
    [self.audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [weakSelf.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:nil];
    
    self.textView.text = @"(listening...)";
}

#pragma mark - SFSpeechRecognizerDelegate

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    
    if (available) {
        self.recordBtn.enabled = YES;
        [self.recordBtn setTitle:@"Start Recording" forState:UIControlStateNormal];
    }
    else {
        self.recordBtn.enabled = YES;
        [self.recordBtn setTitle:@"Recognition not available" forState:UIControlStateNormal];
    }
}

#pragma mark - Actions

- (IBAction)recordBtnTapped:(id)sender {
    
    if ([self.audioEngine isRunning]) {
        [self.audioEngine stop];
        [self.recognitionRequest endAudio];
        self.recordBtn.enabled = NO;
    }
    else {
        [self startRecording];
        [self.recordBtn setTitle:@"Stop Recording" forState:UIControlStateNormal];
    }
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.view endEditing:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
