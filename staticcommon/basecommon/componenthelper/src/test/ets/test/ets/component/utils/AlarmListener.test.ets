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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import {
  DropAnimationCancelReason,
  DropAnimationDestination,
  DropAnimationScene
} from '../../../../../../../../componentanimator/src/main/ets/service/animator/drop/config/DropAnimationConfig';
import { DropAnimationParam, MultiAnimationParam } from '../../../../../../../../componentanimator/src/main/ets/service/animator/drop/bean/DropAnimationParam';
import { dropAnimationManager } from '../../../../../../../../componentanimator/src/main/ets/service/animator/drop/manager/DropAnimationManager';
import { DropDownPanelManagerWrapper, TargetPanel } from '@ohos/frameworkwrapper';

export function AlarmListenerTest() {
  describe('AlarmListenerTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
      dropAnimationManager.addDropItemArray(DropAnimationScene.SCENE_DESKTOP, []);
    })
    afterAll((): void => {

    })
    afterEach((): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
    })

    it('test_addDropItemArray', Level.LEVEL0, (): void => {
      DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_removeDropItemArray', Level.LEVEL0, (): void => {
      DropDownPanelManagerWrapper.getInstance().postWindowEvent('windowName', 1, 1);
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_getDropViewModel', Level.LEVEL0, (): void => {
      DropDownPanelManagerWrapper.getInstance().showWindowDirectly(TargetPanel.NONE);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear', Level.LEVEL0, (): void => {
      DropDownPanelManagerWrapper.getInstance().setTargetPanel(TargetPanel.NOTIFICATION_PANEL);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem', Level.LEVEL0, (): void => {
      DropDownPanelManagerWrapper.getInstance().getDropDownEvent();
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_desktop', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_prepareDropItem_open_folder', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startMultiDropAnimation_dock', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DOCK, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_folder', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_cancelDropAnimation_close_folder', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_startMultiDropAnimation_open_folder', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.OPEN_FOLDER, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_getDropViewModel', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_removeDropItemArray01', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_getDropViewModel01', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear01', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem01', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount01', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount01', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock01', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation01', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock01', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation01', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock01', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop01', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock01', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_desktop01', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_prepareDropItem_open_folder01', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startMultiDropAnimation_dock01', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DOCK, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_folder01', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_cancelDropAnimation_close_folder01', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_startMultiDropAnimation_open_folder01', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.OPEN_FOLDER, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_removeDropItemArray02', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_getDropViewModel02', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear02', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem02', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount02', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount02', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock02', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation02', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock02', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation02', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock02', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop02', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock02', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_desktop02', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_prepareDropItem_open_folder02', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startMultiDropAnimation_dock02', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DOCK, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_folder02', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_cancelDropAnimation_close_folder02', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_startMultiDropAnimation_open_folder02', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.OPEN_FOLDER, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_removeDropItemArray03', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_getDropViewModel03', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear03', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem03', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount03', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount03', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock03', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation03', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock03', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation03', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock03', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop03', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock03', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_desktop03', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_prepareDropItem_open_folder03', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startMultiDropAnimation_dock03', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DOCK, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_folder03', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_cancelDropAnimation_close_folder03', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_startMultiDropAnimation_open_folder03', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.OPEN_FOLDER, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_removeDropItemArray04', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_getDropViewModel04', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear04', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem04', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount04', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount04', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock04', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation04', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock04', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation04', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock04', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop04', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock04', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_desktop04', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_prepareDropItem_open_folder04', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startMultiDropAnimation_dock04', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DOCK, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_folder04', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_cancelDropAnimation_close_folder04', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_startMultiDropAnimation_open_folder04', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.OPEN_FOLDER, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_removeDropItemArray05', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_getDropViewModel05', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear05', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem05', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount05', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount05', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock05', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation05', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock05', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation05', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock05', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop05', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock05', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_desktop05', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_prepareDropItem_open_folder05', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startMultiDropAnimation_dock05', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DOCK, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_folder05', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_cancelDropAnimation_close_folder05', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_startMultiDropAnimation_open_folder05', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.OPEN_FOLDER, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_removeDropItemArray06', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_getDropViewModel06', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear06', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem06', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount06', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount06', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock06', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation06', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock06', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation06', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock06', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop06', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock06', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_desktop06', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_prepareDropItem_open_folder06', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startMultiDropAnimation_dock06', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DOCK, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_folder06', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_cancelDropAnimation_close_folder06', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_startMultiDropAnimation_open_folder06', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.OPEN_FOLDER, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_removeDropItemArray07', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_getDropViewModel07', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear07', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem07', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount07', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount07', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock07', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation07', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock07', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation07', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock07', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop07', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock07', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_desktop07', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_prepareDropItem_open_folder07', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startMultiDropAnimation_dock07', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DOCK, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_folder07', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_cancelDropAnimation_close_folder07', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_startMultiDropAnimation_open_folder07', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.OPEN_FOLDER, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_removeDropItemArray08', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_getDropViewModel08', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear08', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem08', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount08', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount08', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock08', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation08', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock08', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation08', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock08', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop08', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock08', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_desktop08', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_prepareDropItem_open_folder08', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startMultiDropAnimation_dock08', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DOCK, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_folder08', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_cancelDropAnimation_close_folder08', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_startMultiDropAnimation_open_folder08', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.OPEN_FOLDER, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_removeDropItemArray09', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_getDropViewModel09', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear09', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem09', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount09', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount09', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock09', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation09', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock09', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation09', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock09', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop09', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock09', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_desktop09', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_prepareDropItem_open_folder09', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startMultiDropAnimation_dock09', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DOCK, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_folder09', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_cancelDropAnimation_close_folder09', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_startMultiDropAnimation_open_folder09', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.OPEN_FOLDER, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_removeDropItemArray10', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_getDropViewModel10', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear10', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem10', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount10', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount10', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock10', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation10', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock10', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation10', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock10', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop10', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock10', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_desktop10', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_prepareDropItem_open_folder10', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startMultiDropAnimation_dock10', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DOCK, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_folder10', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_cancelDropAnimation_close_folder10', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_startMultiDropAnimation_open_folder10', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.OPEN_FOLDER, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_getDropViewModel10', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear10', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem10', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount10', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount10', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock10', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation10', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock10', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation10', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock10', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop10', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock11', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_removeDropItemArray11', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_DESKTOP);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_getDropViewModel11', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear11', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem11', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount11', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount11', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock11', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation11', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 1, 1, 1, 1);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock11', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation11', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 1, 1);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 1, 1, 2, 2);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock11', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop11', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock11', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_desktop11', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_prepareDropItem_open_folder11', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.OPEN_FOLDER, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startMultiDropAnimation_dock11', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DOCK, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_cancelDropAnimation_swipe_folder11', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_cancelDropAnimation_close_folder11', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.CLOSE_FOLDER);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_startMultiDropAnimation_open_folder11', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 2, 2, 4, 4);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 6, 6, 7, 7);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.OPEN_FOLDER, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_getDropViewModel11', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_clear11', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(0);
    })

    it('test_prepareDropItem11', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_getDropAnimationSceneCount11', Level.LEVEL0, (): void => {
      let arrayMapSize: number = dropAnimationManager.getDropAnimationSceneCount();
      expect(arrayMapSize).assertEqual(0);
    })

    it('test_getDropItemCount11', Level.LEVEL0, (): void => {
      let dropItemCount1: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP);
      expect(dropItemCount1).assertEqual(1);
      let dropItemCount2: number = dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropItemCount2).assertEqual(2);
    })

    it('test_prepareDropItem_dock11', Level.LEVEL0, (): void => {
      dropAnimationManager.prepareDropItem(0);
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '1');
      dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK, '2');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_DESKTOP)).assertEqual(1);
    })

    it('test_startDropAnimation11', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 10, 10);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 20, 20, 30, 30);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock11', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation11', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 5, 5, 10, 10);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 10, 10, 20, 20);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock11', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop11', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })

    it('test_getDropViewModel_screen_lock11', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
    })

    it('test_startDropAnimation', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 0, 0, 10, 10);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm1)).assertTrue();
      let parm2: DropAnimationParam = new DropAnimationParam('2', 10, 10, 10, 10);
      expect(dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, parm2)).assertFalse();
    })

    it('test_removeDropItemArray_screen_lock', Level.LEVEL0, (): void => {
      dropAnimationManager.removeDropItemArray(DropAnimationScene.SCENE_SCREEN_LOCK);
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(0);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_startMultiDropAnimation', Level.LEVEL0, (): void => {
      let parm1: DropAnimationParam = new DropAnimationParam('1', 10, 10, 20, 20);
      let parm2: DropAnimationParam = new DropAnimationParam('1', 30, 30, 40, 40);
      let parm: DropAnimationParam[] = [parm1, parm2];
      expect(dropAnimationManager.startMultiDropAnimation({target: DropAnimationDestination.DESKTOP, paramList: parm} as MultiAnimationParam)).assertEqual(1);
    })

    it('test_clear_screen_lock', Level.LEVEL0, (): void => {
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_SCREEN_LOCK, '1');
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(1);
      dropAnimationManager.clear();
      expect(dropAnimationManager.getDropAnimationSceneCount()).assertEqual(1);
      expect(dropAnimationManager.getDropItemCount(DropAnimationScene.SCENE_SCREEN_LOCK)).assertEqual(0);
    })

    it('test_cancelDropAnimation_desktop', Level.LEVEL0, (): void => {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)).assertTrue();
      expect(dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_SCREEN_LOCK)).assertTrue();
    })
  })
}