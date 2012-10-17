//
//  UIPickerWithToolBarView.m
//  yungujia
//
//  Created by Lee Justin on 12-10-17.
//
//

#import "UIPickerWithToolBarView.h"

@implementation UIPickerWithToolBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self buildPickerToolBar];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self buildPickerToolBar];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    
    [super dealloc];
}

#pragma mark ToolBar

-(void)onToolBarDoneButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onPushedToolBarDoneButton:)])
    {
        id<UIPickerWithToolBarViewDelegate> del = (id<UIPickerWithToolBarViewDelegate>)self.delegate;
        [del onPushedToolBarDoneButton:self];
    }
}

-(void)buildPickerToolBar
{
    UIToolbar* toolBar = nil;
    CGRect toolBarRect = self.frame;
    toolBarRect.origin.y -= 40;
    toolBarRect.size.height = 40;
    toolBar = [[UIToolbar alloc] initWithFrame:toolBarRect];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    toolBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *flexibleWidth = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(onToolBarDoneButton:)];
    
    [toolBar setItems:[NSArray arrayWithObjects:flexibleWidth,doneButton,nil]];
    
    self.toolBar = toolBar;
    self.doneButton = doneButton;
    
    [flexibleWidth release];
    [doneButton release];
    [toolBar release];
}

-(void)resetToolBar
{
    CGRect toolBarRect = self.frame;
    toolBarRect.origin.y -= 40;
    toolBarRect.size.height = 40;
    _toolBar.frame = toolBarRect;
    [_toolBar removeFromSuperview];
    [self.superview addSubview:_toolBar];
}

#pragma mark Redefine Properties

-(void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    [self resetToolBar];
    self.toolBar.hidden = hidden;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resetToolBar];
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self resetToolBar];
}

@end
