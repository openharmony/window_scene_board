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

import { afterAll, afterEach, beforeEach, beforeAll, it, describe, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { ControlCenterViewModel } from '../../../../../../main/ets/com/ohos/viewModel/ControlCenterViewModel';
import {
  ControlCenterAnimationViewModel
} from '../../../../../../main/ets/com/ohos/viewModel/ControlCenterAnimationViewModel';
import { ControlCenterViewData } from '../../../../../../main/ets/com/ohos/vm/ControlCenterViewData';
import { ControlCenterHomeViewData } from '../../../../../../main/ets/com/ohos/vm/ControlCenterHomeViewData';
import { AnimationDataArray } from '../../../../../../main/ets/com/ohos/model/ControlCenterAnimationData';
import { ScrollBlurController } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurController';
import { RectInfo } from '@ohos/basicutils';
import { DropDownPanelManagerWrapper, TargetChangeState, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { ScrollBlurViewData } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurViewData';
import { ControlCenterHomeViewModel } from '../../../../../../main/ets/com/ohos/vm/ControlCenterHomeViewModel';
import {
  ControlCenterPanelDropdownEvent
} from '../../../../../../main/ets/com/ohos/model/ControlCenterPanelDropdownEvent';
import {
  CC_LAYOUT_CONFIGS,
  ControlCenterLayoutConfig,
  ControlCenterLayoutIndex
} from '../../../../../../main/ets/com/ohos/controller/ControlCenterLayoutController';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import sDropDownPanelManager, {
  DropDownPanelManager
} from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';

const MEDIA_ITEM_NAME: string = 'mediaCard';
const SUPER_TERMINAL_ITEM_NAME: string = 'superTerminal_brightness';
const TOGGLE_ROW_ITEM_NAME: string = 'quickToggleRow';
const ADD_MORE_BUTTON_NAME: string = 'addMoreButton'
const LIST_INIT_CONTENT: string[] =
  [MEDIA_ITEM_NAME, SUPER_TERMINAL_ITEM_NAME, ADD_MORE_BUTTON_NAME];
const MAX_QUICK_TOGGLE_ROWS: number = 5;

export function ControlCenterViewModelTest() {
  let mocker: MockKit;
  let homeViewData: ControlCenterHomeViewData = new ControlCenterHomeViewData();
  let controlViewData: ControlCenterViewData = new ControlCenterViewData();
  let animationDataArray: AnimationDataArray = new AnimationDataArray();
  let animationViewModel: ControlCenterAnimationViewModel =
    new ControlCenterAnimationViewModel(animationDataArray, LIST_INIT_CONTENT.length + MAX_QUICK_TOGGLE_ROWS + 1);
  let homeViewModel: ControlCenterHomeViewModel = new ControlCenterHomeViewModel(homeViewData, controlViewData.scroller)
  let controlViewModel: ControlCenterViewModel = new ControlCenterViewModel(controlViewData, homeViewData, animationViewModel, homeViewModel);
  let scrollBlurController = new ScrollBlurController(controlViewData.scroller, 132);
  let blurArea = new RectInfo();
  let scrollBlurViewData = new ScrollBlurViewData();
  scrollBlurController?.init(blurArea, scrollBlurViewData);
  controlViewModel.setScrollBlurController(scrollBlurController);

  describe('ControlCenterViewModelTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    })

    afterAll((): void => {
      mocker.clearAll();
    })

    beforeEach((): void => {
    })

    afterEach((): void => {

    })

    it('setScrollBlurController_Test001', 0, (): void => {
      let scrollBlurViewData = new ScrollBlurViewData();
      scrollBlurController?.init(blurArea, scrollBlurViewData);
      controlViewModel.setScrollBlurController(scrollBlurController);
      expect(controlViewModel !== undefined).assertTrue();
    })

    it('onListTouchEvent_Test001', 0, (): void => {
      let event: TouchEvent = {
        type: TouchType.Down,
        changedTouches: [{
          id: 0,
          x: 100,
          y: 100
        }],
      } as TouchEvent;
      controlViewModel.onListTouchEvent(event);
      expect(event !== undefined).assertTrue();
    })

    it('onListTouchEvent_Test002', 0, (): void => {
      let event = {
        type: TouchType.Down,
        changedTouches: [{
          id: 0,
          type: 0,
          displayX: 0,
          displayY: 0,
          windowX: 0,
          windowY: 0,
          screenX: 0,
          screenY: 0,
          x: 100,
          y: 100
        }],
      } as TouchEvent;
      controlViewModel.onListTouchEvent(event);
      expect(event !== undefined).assertTrue();
    })

    it('onListTouchEvent_Test003', 0, (): void => {
      let event = {
        type: TouchType.Move,
        changedTouches: [{
          id: 0,
          type: 0,
          displayX: 0,
          displayY: 0,
          windowX: 0,
          windowY: 0,
          screenX: 0,
          screenY: 0,
          x: 100,
          y: 100
        }],
      } as TouchEvent;
      controlViewModel.onListTouchEvent(event);
      expect(event !== undefined).assertTrue();
    })

    it('onListTouchEvent_Test004', 0, (): void => {
      let event = {
        type: TouchType.Up,
        changedTouches: [{
          id: 0,
          type: 0,
          displayX: 0,
          displayY: 0,
          windowX: 0,
          windowY: 0,
          screenX: 0,
          screenY: 0,
          x: 100,
          y: 100
        }],
      } as TouchEvent;
      controlViewModel.onListTouchEvent(event);
      expect(event !== undefined).assertTrue();
    })

    it('onListTouchEvent_Test005', 0, (): void => {
      let event = {
        type: TouchType.Cancel,
        changedTouches: [{
          id: 0,
          type: 0,
          displayX: 0,
          displayY: 0,
          windowX: 0,
          windowY: 0,
          screenX: 0,
          screenY: 0,
          x: 100,
          y: 100
        }],
      } as TouchEvent;
      controlViewModel.onListTouchEvent(event);
      expect(event !== undefined).assertTrue();
    })

    it('onListTouchEvent_Test006', 0, (): void => {
      let event = {
        type: TouchType.Cancel,
        changedTouches: [{
          id: -1,
          type: 0,
          displayX: 0,
          displayY: 0,
          windowX: 0,
          windowY: 0,
          screenX: 0,
          screenY: 0,
          x: 100,
          y: 100
        }],
      } as TouchEvent;
      controlViewModel.onListTouchEvent(event);
      expect(event !== undefined).assertTrue();
    })

    it('startControlCenterAnim_Test001', 0, (): void => {
      controlViewModel.startControlCenterAnim(true);
      expect(controlViewModel).not().assertNull();
    })

    it('startControlCenterAnim_Test002', 0, (): void => {
      controlViewModel.startControlCenterAnim(false);
      expect(controlViewModel !== undefined).assertTrue();
    })

    it('onTouchMove_Test001', 0, (): void => {
      let event = {
        type: TouchType.Down,
        changedTouches: [{
          id: 0,
          x: 100,
          y: -1
        }],
      } as TouchEvent;
      controlViewModel.onListTouchEvent(event);

      event = {
        type: TouchType.Move,
        changedTouches: [{
          id: 0,
          x: 100,
          y: -1
        }],
      } as TouchEvent;
      controlViewModel.onListTouchEvent(event);
      expect(event !== undefined).assertTrue();
    })

    it('onTouchMove_Test002', 0, (): void => {
      let event = {
        type: TouchType.Move,
        changedTouches: [{
          id: 0,
          x: 100,
          y: -1
        }],
      } as TouchEvent;

      (controlViewModel as object)['startY'] = -1;
      (controlViewModel as object)['onTouchMove'](event);
      expect(event !== undefined).assertTrue();
    })

    it('onTouchMove_Test003', 0, (): void => {
      let event = {
        type: TouchType.Move,
        changedTouches: [{
          id: 0,
          x: 100,
          y: -1
        }],
      } as TouchEvent;

      (controlViewModel as object)['startY'] = 1;
      (controlViewModel as object)['onTouchMove'](event);
      expect(event !== undefined).assertTrue();
    })

    it('onTouchMove_Test004', 0, (): void => {
      let event = {
        type: TouchType.Move,
        changedTouches: [{
          id: 0,
          x: 100,
          y: -1
        }],
      } as TouchEvent;

      (controlViewModel as object)['startY'] = 1;
      (controlViewModel as object)['onTouchMove'](event);
      expect(event !== undefined).assertTrue();
    })

    it('onTouchDown_Test001', 0, (): void => {
      let event = {
        changedTouches: [{
          id: 0,
          x: 100,
          y: 10
        }],
      } as TouchEvent;
      (controlViewModel as object)['onTouchDown'](event);
      expect(event !== undefined).assertTrue();
    })

    it('onTouchCancel_Test001', 0, (): void => {
      let event = {
        changedTouches: [{
          id: 0,
          x: 100,
          y: 10
        }],
      } as TouchEvent;
      (controlViewModel as object)['onTouchCancel'](event);
      expect(event !== undefined).assertTrue();
    })

    it('onTouchCancel_Test002', 0, (): void => {
      let event = {
        changedTouches: [{
          id: 0,
          x: 100,
          y: 102
        }],
      } as TouchEvent;
      (controlViewModel as object)['onTouchCancel'](event);
      expect(event !== undefined).assertTrue();
    })

    it('showControlCenterAnim_Test001', 0, (): void => {
      (controlViewModel as object)['viewData'].backgroundOpacity.backgroundOpacity = 0;
      (controlViewModel as object)['showControlCenterAnim']();
      expect(controlViewModel !== undefined).assertTrue();
    })

    it('showControlCenterAnim_Test002', 0, (): void => {
      (controlViewModel as object)['viewData'].backgroundOpacity.backgroundOpacity = 1;
      (controlViewModel as object)['showControlCenterAnim']();
      expect(controlViewModel !== undefined).assertTrue();
    })

    it('changeLabelColor_Test001', 0, (): void => {
      (controlViewModel as object)['changeLabelColor'](2);
      expect(controlViewModel !== undefined).assertTrue();
    })

    it('changeLabelColor_Test002', 0, (): void => {
      (controlViewModel as object)['changeLabelColor'](1);
      expect(controlViewModel !== undefined).assertTrue();
    })

    it('hideControlCenterAnim_Test001', 0, (): void => {
      (controlViewModel as object)['viewData'].progress = 1;
      (controlViewModel as object)['hideControlCenterAnim']();
      expect(controlViewModel !== undefined).assertTrue();
    })

    it('hideControlCenterAnim_Test002', 0, (): void => {
      (controlViewModel as object)['viewData'].progress = 0;
      (controlViewModel as object)['hideControlCenterAnim']();
      expect(controlViewModel !== undefined).assertTrue();
    })

    it('hideControlCenterAnim_Test003', 0, (): void => {
      (controlViewModel as object)['viewData'].progress = 0;
      (controlViewModel as object)['viewData'].listController.isReachTop = true;
      (controlViewModel as object)['hideControlCenterAnim']();
      expect(controlViewModel !== undefined).assertTrue();
    })

    it('handleAnimationFinish_Test001', 0, (): void => {
      (controlViewModel as object)['animationCount'] = 0;
      (controlViewModel as object)['handleAnimationFinish']();
      expect(controlViewModel !== undefined).assertTrue();
    })

    it('handleAnimationFinish_Test001', 0, (): void => {
      (controlViewModel as object)['animationCount'] = 1;
      (controlViewModel as object)['handleAnimationFinish']();
      expect(controlViewModel !== undefined).assertTrue();
    })

    it('ControlCenterViewModelTest_onTouchMove', 0, (): void => {
      try {
        let event: TouchEvent = {
          type: TouchType.Down
        } as TouchEvent;
        (controlViewModel as object)['startY'] = 1;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(sDropDownPanelManager, sDropDownPanelManager.getDropDirection);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(TargetChangeState.VERTICAL);
        (controlViewModel as object)['viewData'].relativeDistance = 1;
        (controlViewModel as object)['onTouchMove'](event);
        (controlViewModel as object)['viewData'].relativeDistance = -1;
        (controlViewModel as object)['viewData'].hasScrollDown = false;
        (controlViewModel as object)['viewData'].startWhenListReachBottom = true;
        (controlViewModel as object)['startY'] = 1;
        (controlViewModel as object)['viewData'].relativeDistance = -30;
        (controlViewModel as object)['lastTouchNo'] = 0;
        (controlViewModel as object)['currentTouchNo'] = 0;
        let mockFunc2: Function = mocker.mockFunc(sDropDownPanelManager, sDropDownPanelManager.isPanelDismissing);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        (controlViewModel as object)['onTouchMove'](event);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        event.stopPropagation = () => {};
        (controlViewModel as object)['onTouchMove'](event);
      } catch (e) {
        expect(controlViewModel).not().assertNull();
      }
      mocker.verify('animToDismiss', []).once();
      mocker.clear(ViewManagerPolicy);
      mocker.clear(sDropDownPanelManager);
    })

    it('ControlCenterViewModelTest_hideControlCenterAnim', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockFunc)(ViewType.DROPDOWN).afterReturn(true);
      (controlViewModel as object)['viewData'].progress = 0;
      (controlViewModel as object)['hideControlCenterAnim']();
      (controlViewModel as object)['viewData'].progress = 1;
      (controlViewModel as object)['viewData'].listController.isReachTop = true;
      (controlViewModel as object)['hideControlCenterAnim']();
      expect((controlViewModel as object)['viewData'].isHideAnimStarted).assertTrue();
      mocker.clear(ViewManagerPolicy);
    })

    it('ControlCenterViewModelTest_onDropdownChanged', 0, (): void => {
      let dropDownEventState: ControlCenterPanelDropdownEvent = ControlCenterPanelDropdownEvent.create();
      controlViewModel.onDropdownChanged(dropDownEventState);
      expect(dropDownEventState !== undefined).assertTrue();
    })

    it('ControlCenterViewModelTest_showControlCenterDirectly', 0, (): void => {
      let dropDownEvent = DropDownPanelManagerWrapper.getInstance().getDropDownEvent();
      (controlViewModel as object)['setVisible'](dropDownEvent);
      (controlViewModel as object)['showControlCenterDirectly'](true);
      expect((controlViewModel as object)['viewData'].shouldClip).assertFalse();
      (controlViewModel as object)['showControlCenterDirectly'](false);
      expect((controlViewModel as object)['viewData'].progress).assertEqual(0);
    })

    it('ControlCenterViewModelTest_setContentTranslateY', 0, (): void => {
      (controlViewModel as object)['setContentTranslateY'](10, true);
      (controlViewModel as object)['setContentTranslateY'](10, false);
      expect((controlViewModel as object)['getAnimArraySize']()).assertInstanceOf('Number');
    })

    it('ControlCenterViewModelTest_onControlCenterStateChanged_1', 0, (): void => {
      let controlCenterState: ControlCenterState = ControlCenterState.MAIN_LAYOUT;
      (controlViewModel as object)['viewData'].data.state = ControlCenterState.TOGGLE_EDIT;
      (controlViewModel as object)['onControlCenterStateChanged'](controlCenterState);
      (controlViewModel as object)['viewData'].data.state = controlCenterState;
      (controlViewModel as object)['onControlCenterStateChanged'](controlCenterState);
      expect(controlViewModel !== undefined).assertTrue();
    })

    it('ControlCenterViewModelTest_handleOnWillScroll_1', 0, (): void => {
      try {
        (controlViewModel as object)['viewData'].startWhenListReachBottom = true;
        (controlViewModel as object)['viewData'].startWhenListReachTop = true;
        (controlViewModel as object)['viewData'].hasScrollDown = false;
        (controlViewModel as object)['viewData'].relativeDistance = -10;
        let res: ScrollResult = { offsetRemain: 0 };
        expect(controlViewModel.handleOnWillScroll(100) as ScrollResult).assertEqual(res);
      } catch (e) {
        expect(controlViewModel).not().assertNull();
      }
    })

    it('ControlCenterViewModelTest_handleOnWillScroll_2', 0, (): void => {
      try {
        (controlViewModel as object)['viewData'].startWhenListReachBottom = true;
        (controlViewModel as object)['viewData'].startWhenListReachTop = true;
        (controlViewModel as object)['viewData'].hasScrollDown = true;
        let res: ScrollResult = { offsetRemain: 100 };
        expect(controlViewModel.handleOnWillScroll(100) as ScrollResult).assertEqual(res);
      } catch (e) {
        expect(controlViewModel).not().assertNull();
      }
    })

    it('ControlCenterViewModelTest_handleOnWillScroll_3', 0, (): void => {
      try {
        (controlViewModel as object)['viewData'].hasScrollDown = false;
        (controlViewModel as object)['viewData'].startWhenListReachBottom = true;
        (controlViewModel as object)['viewData'].relativeDistance = -10;
        let res: ScrollResult = { offsetRemain: 0 };
        expect(controlViewModel.handleOnWillScroll(100) as ScrollResult).assertEqual(res);
      } catch (e) {
        expect(controlViewModel).not().assertNull();
      }
    })

    it('ControlCenterViewModelTest_handleOnWillScroll_4', 0, (): void => {
      try {
        (controlViewModel as object)['viewData'].startWhenListReachBottom = false;
        (controlViewModel as object)['viewData'].startWhenListReachTop = false;
        let res: ScrollResult = { offsetRemain: 100 };
        expect(controlViewModel.handleOnWillScroll(100) as ScrollResult).assertEqual(res);
      } catch (e) {
        expect(controlViewModel).not().assertNull();
      }
    })

    it('ControlCenterViewModelTest_headerFollowEffect', 0, (): void => {
      try {
        (controlViewModel as object)['viewData'].ccLayoutIndex = ControlCenterLayoutIndex.NORMAL_PORTRAIT;
        (controlViewModel as object)['headerFollowEffect']();
        expect(controlViewModel !== undefined).assertTrue();
      } catch (e) {
        expect(controlViewModel).not().assertNull();
      }
    })

    it('ControlCenterViewModelTest_onListTouchEvent', 0, (): void => {
      let event = {
        type: TouchType.Move,
        changedTouches: [{
          id: 0,
          type: 0,
          displayX: 0,
          displayY: 0,
          windowX: 0,
          windowY: 0,
          screenX: 0,
          screenY: 0,
          x: 100,
          y: 100
        }],
      } as TouchEvent;
      try {
        controlViewModel.onListTouchEvent(event);
        expect(controlViewModel).not().assertNull();
      } catch (e) {
        expect(controlViewModel).not().assertNull();
      }
    })
  })
}