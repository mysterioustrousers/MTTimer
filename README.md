MTTimer
=======

An Objective-C timer that restricts firing to a time range. If it's dismissed BEFORE min, it waits for min. If it's dismissed AFTER max, it's called at max.

Developed for [Firehose](https://getfirehose.com) by [Mysterious Trousers](https://www.mysterioustrousers.com)

### Example

    @implementation FMRootWindowView {
    	MTTimer *_durationTimer;
    }

    #pragma mark - Public

    - (void)displayLoadingWithMessage:(NSString *)message
    {
		...

		// It's kind of jolting to see a loading message pop up and disappear in 
		// just a few miliseconds, in the case of a request that loads very quickly, 
		// so we constrain the timer to not fire until at least 2 seconds, even if
		// `done` is called before that.
        _durationTimer = [MTTimer timerThatMustLastAtLeast:2 untilPerformingBlock:^{
            // do whatever you do when it's done
        }];

        ...
    }

    - (void)displaySuccessWithMessage:(NSString *)errorMessage
    {
		...

		// We want a the success message to show for at least 2 seconds, but we 
		// don't want it showing more than 4.
        _durationTimer = [MTTimer timerThatMustLastAtLeast:2 atMost:4 beforePerformingBlock:^{
            // do whatever you do when it's done
        }];

        ...
    }

    - (void)displayErrorWithMessage:(NSString *)errorMessage
    {
		...
		
		// We want a the error message to show for at least 30 seconds, to make 
		// sure the user sees it.
        _durationTimer = [MTTimer timerThatMustLastAtLeast:30 atMost:35 beforePerformingBlock:^{
            [self animateUp];
        }];

		...
    }

    - (void)dismissStatus
    {
    	// This is called whenever your external operation is complete. If `done` is calle BEFORE
    	// the min seconds has been reached, the completion block will not fire until min is reached.
    	// If you call this AFTER max, the completion block will have already fired when max was reached.
        [_durationTimer done];
    }

    @end
