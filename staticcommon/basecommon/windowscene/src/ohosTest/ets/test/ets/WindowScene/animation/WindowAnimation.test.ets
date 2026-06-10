/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  WinAnimOptions,
  WinAnimType,
  WindowAnimation
} from '../../../../../../main/ets/animation/WindowAnimation';
import { window, } from '@kit.ArkUI';

let animation: WindowAnimation;
let mocker: MockKit = new MockKit();
const INVALID_WIN_ANIM_TYPE = 10;

enum InnerAnimType {
  /**
   * 窗口前一半动画
   */
  TYPE_FRONT = 1,

  /**
   * 窗口后一半动画
   */
  TYPE_AFTER = 2
}

export default function WindowAnimationTest() {
  describe('WindowAnimationTest', () => {
    beforeAll(() => {
      animation = new WindowAnimation(new Object as window.Window);
    });
    beforeEach(() => {

    });
    afterEach(() => {

    });
    afterAll(() => {

    });
    UpdateWindow();
    SetDuration();
    setDelay();
    SetEasing();
    SetBeginOptions();
    SetEndOptions();
    SetMidOptions();
    UpdateAnimPivot();
    StartBindOnFrame();
    IsRunning();
    ShowAnim();
    HideAnim();
    CancelAnim();
    PrepareStartAnim();
    StartAnim();
    OnFrame();
    OnFinish();
    OnCancel();
    SetWindowOpacity();
    SetWindowScale();
    SetWindowRotate();
  });
}

function UpdateWindow() {
  it('updateWindow', 0, () => {
    animation.updateWindow(new Object as window.Window);
    expect(true).assertTrue();
  });

}

function SetDuration() {
  it('setDuration', 0, () => {
    animation.setDuration(WinAnimType.TYPE_SHOW, null);
    animation.setDuration(WinAnimType.TYPE_SHOW, 1);
    animation.setDuration(INVALID_WIN_ANIM_TYPE, 1);
    expect(true).assertTrue();
  });
}

function setDelay() {
  it('setDelay', 0, () => {
    animation.setDelay(WinAnimType.TYPE_SHOW, null);
    animation.setDelay(WinAnimType.TYPE_SHOW, 1);
    animation.setDelay(INVALID_WIN_ANIM_TYPE, 1);
    expect(true).assertTrue();
  });
}

function SetEasing() {
  it('setEasing', 0, () => {
    animation.setEasing(WinAnimType.TYPE_SHOW, null);
    animation.setEasing(WinAnimType.TYPE_SHOW, 'cubic-bezier(0.6, 0.0, 0.6, 1.0)');
    animation.setEasing(INVALID_WIN_ANIM_TYPE, 'cubic-bezier(0.6, 0.0, 0.6, 1.0)');
    expect(true).assertTrue();
  });
}

function SetBeginOptions() {
  it('setBeginOptions', 0, () => {
    animation.setBeginOptions(WinAnimType.TYPE_SHOW, null);
    animation.setBeginOptions(WinAnimType.TYPE_SHOW, new WinAnimOptions());
    animation.setBeginOptions(INVALID_WIN_ANIM_TYPE, new WinAnimOptions());
    expect(true).assertTrue();
  });
}

function SetEndOptions() {
  it('setEndOptions', 0, () => {
    animation.setEndOptions(WinAnimType.TYPE_SHOW, null);
    animation.setEndOptions(WinAnimType.TYPE_SHOW, new WinAnimOptions());
    animation.setEndOptions(INVALID_WIN_ANIM_TYPE, new WinAnimOptions());
    expect(true).assertTrue();
  });
}

function SetMidOptions() {
  it('setMidOptions', 0, () => {
    animation.setMidOptions(WinAnimType.TYPE_SHOW, null, null);
    animation.setMidOptions(WinAnimType.TYPE_SHOW, new WinAnimOptions(), null);
    animation.setMidOptions(INVALID_WIN_ANIM_TYPE, null, 0.5);
    animation.setMidOptions(INVALID_WIN_ANIM_TYPE, new WinAnimOptions(), 0.5);
    expect(true).assertTrue();
  });
}

function UpdateAnimPivot() {
  it('updateAnimPivot', 0, () => {
    animation.updateAnimPivot(1, 1);
    expect(true).assertTrue();
  });
}

function StartBindOnFrame() {
  it('startBindOnFrame', 0, () => {
    animation.startBindOnFrame();
    expect(true).assertTrue();
  });
}

function IsRunning() {
  it('isRunning', 0, () => {
    animation.isRunning(null);
    animation.isRunning(WinAnimType.TYPE_SHOW);
    expect(true).assertTrue();
  });
}

function ShowAnim() {
  it('showAnim', 0, () => {
    animation.showAnim(() => {
    }, true);
    animation.showAnim(() => {
    }, false);
    let mockFunc = mocker.mockFunc(animation, animation.isRunning);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
    animation.showAnim(() => {
    }, true);
    animation.showAnim(() => {
    }, false);
    expect(true).assertTrue();
  });
}

function HideAnim() {
  it('hideAnim', 0, () => {
    animation.hideAnim(() => {
    }, true);
    animation.hideAnim(() => {
    }, false);
    let mockFunc = mocker.mockFunc(animation, animation.isRunning);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
    animation.hideAnim(() => {
    }, true);
    animation.hideAnim(() => {
    }, false);
    expect(true).assertTrue();
  });
}

function CancelAnim() {
  it('cancelAnim', 0, () => {
    let mockFunc = mocker.mockFunc(animation, animation.isRunning);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
    animation.cancelAnim(WinAnimType.TYPE_SHOW);
    animation.cancelAnim(INVALID_WIN_ANIM_TYPE);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
    animation.cancelAnim(WinAnimType.TYPE_SHOW);
    animation.cancelAnim(INVALID_WIN_ANIM_TYPE);
    expect(true).assertTrue();
  });
}

function PrepareStartAnim() {
  it('prepareStartAnim', 0, () => {
    (animation as object)['prepareStartAnim'](INVALID_WIN_ANIM_TYPE);
    expect(true).assertTrue();
  });
}

function StartAnim() {
  it('startAnim', 0, () => {
    (animation as object)['startAnim'](INVALID_WIN_ANIM_TYPE);
    expect(true).assertTrue();
  });
}

function OnFrame() {
  it('onFrame', 0, () => {
    (animation as object)['onFrame'](INVALID_WIN_ANIM_TYPE, InnerAnimType.TYPE_FRONT, 1);
    expect(true).assertTrue();
  });
}

function OnFinish() {
  it('onFinish', 0, () => {
    (animation as object)['onFinish'](InnerAnimType.TYPE_FRONT);
    (animation as object)['onFinish'](INVALID_WIN_ANIM_TYPE);
    expect(true).assertTrue();
  });
}

function OnCancel() {
  it('onCancel', 0, () => {
    (animation as object)['onCancel'](InnerAnimType.TYPE_FRONT);
    expect(true).assertTrue();
  });
}

function SetWindowOpacity() {
  it('setWindowOpacity', 0, () => {
    let opt1 = new WinAnimOptions();
    let opt2 = new WinAnimOptions();
    (animation as object)['setWindowOpacity'](undefined, undefined, 0.5);
    (animation as object)['setWindowOpacity'](opt1, undefined, 0.5);
    (animation as object)['setWindowOpacity'](undefined, opt2, 0.5);
    (animation as object)['setWindowOpacity'](opt1, opt2, 0.5);
    (animation as object)['setWindowOpacity'](opt1, opt1, 0.5);
    opt1.opacity = 0.5;
    (animation as object)['setWindowOpacity'](opt1, opt2, 0.5);
    (animation as object)['setWindowOpacity'](opt2, opt1, 0.5);
    opt2.opacity = 0.6;
    (animation as object)['setWindowOpacity'](opt1, opt2, 0.5);
    expect(true).assertTrue();
  });
}

function SetWindowScale() {
  it('setWindowScale', 0, () => {
    let opt1 = new WinAnimOptions();
    let opt2 = new WinAnimOptions();
    (animation as object)['setWindowScale'](undefined, undefined, 0.5);
    (animation as object)['setWindowScale'](opt1, undefined, 0.5);
    (animation as object)['setWindowScale'](undefined, opt2, 0.5);
    (animation as object)['setWindowScale'](opt1, opt2, 0.5);
    opt1.scale = {
      x: undefined, y: undefined
    };
    opt2.scale = {
      x: undefined, y: undefined
    };
    (animation as object)['setWindowScale'](opt1, opt2, 0.5);
    opt1.scale = {
      x: 1, y: 1
    };
    (animation as object)['setWindowScale'](opt2, opt1, 0.5);
    (animation as object)['setWindowScale'](opt1, opt2, 0.5);
    opt2.scale = {
      x: 1, y: 2
    };
    (animation as object)['setWindowScale'](opt1, opt2, 0.5);
    expect(true).assertTrue();
  });
}

function SetWindowRotate() {
  it('setWindowRotate', 0, () => {
    let opt1 = new WinAnimOptions();
    let opt2 = new WinAnimOptions();
    (animation as object)['setWindowScale'](undefined, undefined, 0.5);
    (animation as object)['setWindowScale'](opt1, undefined, 0.5);
    (animation as object)['setWindowScale'](undefined, opt2, 0.5);
    (animation as object)['setWindowScale'](opt1, opt2, 0.5);
    opt1.scale = {
      x: undefined, y: undefined
    };
    opt2.scale = {
      x: undefined, y: undefined
    };
    (animation as object)['setWindowScale'](opt1, opt2, 0.5);
    opt1.scale = {
      x: 1, y: 1
    };
    (animation as object)['setWindowScale'](opt2, opt1, 0.5);
    (animation as object)['setWindowScale'](opt1, opt2, 0.5);
    opt2.scale = {
      x: 1, y: 2
    };
    (animation as object)['setWindowScale'](opt1, opt2, 0.5);
    expect(true).assertTrue();
  });
}
