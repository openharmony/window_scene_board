/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneContainerSession,
  SCBDividerParam,
  SCBScreenProperty,
  SCBSessionRect,
  SceneParam
} from '@ohos/windowscene';
import { describe, expect, it, Level } from '@ohos/hypium';
import {
  SCBDockSplitHelper,
  SplitSpaceSenseParams
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBDockSplitHelper';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { BoardPreviewModel,
  SCBSignIconParam } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBDockSplitView';
import { SCBAppIconParamEx } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBAppIconEx';
import AllAppsViewModel from '../../../../main/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewevent/AllAppsViewModel';
import {
  GestureDockConstants,
  GestureDockMode
} from '../../../../main/ets/SceneBoard/gestureDock/common/GestureDockConstants';
import SCBGestureDockModel, {
  GestureDockState,
  GestureDockDirection
} from '../../../../main/ets/SceneBoard/gestureDock/dockbar/model/SCBGestureDockViewModel';

let dockSplitHelper: SCBDockSplitHelper = new SCBDockSplitHelper();
let setDividerParam = (dividerParam: SCBDividerParam): void => {};
let getBoardPreviewModel = (): BoardPreviewModel => { return new BoardPreviewModel() };
let setDragIconParam = (): (SCBSignIconParam | null) => { return new SCBSignIconParam('test') };
let getDockScreenProperty = () => new SCBScreenProperty();
let requestSceneSession = (sceneInfo: SCBSceneInfo): SCBSceneSession | null => {
  return sceneInfo ? new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo) : null;
};
let isSupportPairSplit = (
  session: SCBSceneSession,
  container: SCBSceneContainerSession,
  fromDock: boolean
): boolean => {
  return session && container.containerId > 0 && fromDock;
};
let exitRecent = (): void => {};
let sceneInfo = new SCBSceneInfo('testDockBundle', 'testDockModule', 'testDockAbility');


export function SCBDockSplitHelperTest() {
  describe('SCBDockSplitHelperTest_001', () => {
    it('setDividerParamAndModelCallback_001', Level.LEVEL0, (): void => {
      dockSplitHelper.setDividerParamAndModelCallback(setDividerParam,
        getBoardPreviewModel, setDragIconParam, getDockScreenProperty);
      expect(true).assertTrue();
    });

    it('registerCallbackAndModel_001', Level.LEVEL0, (): void => {
      dockSplitHelper.registerCallbackAndModel(requestSceneSession, isSupportPairSplit, exitRecent);
      expect(true).assertTrue();
    });

    it('getDockItemId_001', Level.LEVEL0, (): void => {
      dockSplitHelper.getDockItemId(null);
      expect(true).assertTrue();
      dockSplitHelper.getDockItemId(sceneInfo);
      expect(true).assertTrue();
    });

    it('setDockGrayIcon_001', Level.LEVEL0, (): void => {
      dockSplitHelper.setDockGrayIcon(true, sceneInfo);
      expect(true).assertTrue();
    });

    it('registerMultiDockSwitchStatusChange_001', Level.LEVEL0, (): void => {
      dockSplitHelper.registerMultiDockSwitchStatusChange();
      expect(true).assertTrue();
    });

    it('unregisterMultiDockSwitchStatusChange_001', Level.LEVEL0, (): void => {
      dockSplitHelper.unregisterMultiDockSwitchStatusChange();
      expect(true).assertTrue();
    });

    it('getMultiDockStatus_001', Level.LEVEL0, (): void => {
      dockSplitHelper.getMultiDockStatus();
      expect(true).assertTrue();
    });

    it('copyToSceneParamTest', Level.LEVEL0, (): void => {
      let model = new BoardPreviewModel();
      expect(model.isBoardVisible).assertFalse();
      expect(model.boardOpacity).assertEqual(1);
      expect(model.boardColor).assertEqual(Color.White);
      expect(model.shadowColor).assertEqual(Color.Transparent);
      expect(model.anchorX).assertEqual(0);
      expect(model.anchorY).assertEqual(0);
      expect(model.posX).assertEqual(0);
      expect(model.posY).assertEqual(0);
      expect(model.scaleX).assertEqual(0);
      expect(model.scaleY).assertEqual(0);
      expect(model.width).assertEqual('');
      expect(model.height).assertEqual('');
      let sceneParam = new SceneParam();
      model.copyToSceneParam(sceneParam);
      expect(sceneParam.scaleX).assertEqual(model.scaleX);
      expect(sceneParam.scaleY).assertEqual(model.scaleY);
      expect(sceneParam.width).assertEqual(model.width);
      expect(sceneParam.height).assertEqual(model.height);
      model.isBoardVisible = true;
      model.boardOpacity = 2;
      model.boardColor = Color.Red;
      model.shadowColor = Color.Red;
      model.anchorX = 1;
      model.anchorY = 1;
      model.posX = 1;
      model.posY = 1;
      model.scaleX = 1;
      model.scaleY = 1;
      model.width = '1';
      model.height = '1';
      model.copyToSceneParam(sceneParam);
      expect(sceneParam.width).assertEqual('1');
      expect(sceneParam.height).assertEqual('1');
      expect(sceneParam.scaleX).assertEqual(1);
      expect(sceneParam.scaleY).assertEqual(1);
      model.isBoardVisible = false;
      model.boardOpacity = 3;
      model.boardColor = Color.Green;
      model.shadowColor = Color.Green;
      model.anchorX = 3;
      model.anchorY = 3;
      model.posX = 3;
      model.posY = 3;
      model.scaleX = 3;
      model.scaleY = 3;
      model.width = '3';
      model.height = '3';
      model.copyToSceneParam(sceneParam);
      expect(sceneParam.width).assertEqual('3');
      expect(sceneParam.height).assertEqual('3');
      expect(sceneParam.scaleX).assertEqual(3);
      expect(sceneParam.scaleY).assertEqual(3);
    });

    it('copyFromSceneParamTest', Level.LEVEL0, (): void => {
      let fromModel = new BoardPreviewModel();
      expect(fromModel.isBoardVisible).assertFalse();
      expect(fromModel.boardOpacity).assertEqual(1);
      expect(fromModel.boardColor).assertEqual(Color.White);
      expect(fromModel.shadowColor).assertEqual(Color.Transparent);
      expect(fromModel.anchorX).assertEqual(0);
      expect(fromModel.anchorY).assertEqual(0);
      expect(fromModel.posX).assertEqual(0);
      expect(fromModel.posY).assertEqual(0);
      expect(fromModel.scaleX).assertEqual(0);
      expect(fromModel.scaleY).assertEqual(0);
      expect(fromModel.width).assertEqual('');
      expect(fromModel.height).assertEqual('');
      let sceneParam = new SceneParam();
      sceneParam.posX = '11';
      sceneParam.posY = '11';
      sceneParam.width = '11';
      sceneParam.height = '11';
      sceneParam.scaleX = 1;
      sceneParam.scaleY = 1;
      fromModel.copyFromSceneParam(sceneParam);
      expect(fromModel.posX).assertEqual(sceneParam.posX);
      expect(fromModel.posY).assertEqual(sceneParam.posY);
      expect(fromModel.width).assertEqual(sceneParam.width);
      expect(fromModel.height).assertEqual(sceneParam.height);
      expect(fromModel.scaleX).assertEqual(sceneParam.scaleX);
      expect(fromModel.scaleY).assertEqual(sceneParam.scaleY);
      fromModel.isBoardVisible = true;
      fromModel.boardOpacity = 5;
      fromModel.boardColor = Color.Red;
      fromModel.shadowColor = Color.Red;
      fromModel.anchorX = 5;
      fromModel.anchorY = 5;
      fromModel.posX = 5;
      fromModel.posY = 5;
      fromModel.scaleX = 5;
      fromModel.scaleY = 5;
      fromModel.width = '5';
      fromModel.height = '5';
      sceneParam.posX = '22';
      sceneParam.posY = '22';
      sceneParam.width = '22';
      sceneParam.height = '22';
      sceneParam.scaleX = 2;
      sceneParam.scaleY = 2;
      fromModel.copyFromSceneParam(sceneParam);
      expect(fromModel.posX).assertEqual(sceneParam.posX);
      expect(fromModel.posY).assertEqual(sceneParam.posY);
      expect(fromModel.scaleX).assertEqual(sceneParam.scaleX);
      expect(fromModel.scaleY).assertEqual(sceneParam.scaleY);
      expect(fromModel.width).assertEqual(sceneParam.width);
      expect(fromModel.height).assertEqual(sceneParam.height);
      fromModel.isBoardVisible = false;
      fromModel.boardOpacity = 6;
      fromModel.boardColor = Color.Green;
      fromModel.shadowColor = Color.Green;
      fromModel.anchorX = 6;
      fromModel.anchorY = 6;
      fromModel.posX = 6;
      fromModel.posY = 6;
      fromModel.scaleX = 6;
      fromModel.scaleY = 6;
      fromModel.width = '6';
      fromModel.height = '6';
      sceneParam.posX = '33';
      sceneParam.posY = '33';
      sceneParam.width = '33';
      sceneParam.height = '33';
      sceneParam.scaleX = 3;
      sceneParam.scaleY = 3;
      fromModel.copyFromSceneParam(sceneParam);
      expect(fromModel.posX).assertEqual(sceneParam.posX);
      expect(fromModel.posY).assertEqual(sceneParam.posY);
      expect(fromModel.width).assertEqual(sceneParam.width);
      expect(fromModel.height).assertEqual(sceneParam.height);
      expect(fromModel.scaleX).assertEqual(sceneParam.scaleX);
      expect(fromModel.scaleY).assertEqual(sceneParam.scaleY);
    });

    it('setExtraDockInfo_001', Level.LEVEL0, (): void => {
      let extraInfo: number[] | undefined = [-1, 1];
      dockSplitHelper.setExtraDockInfo(extraInfo);
      expect(dockSplitHelper.isAllAppsIcon).assertTrue();
      expect(dockSplitHelper.gestureDockAllAppsIcon).assertEqual(extraInfo[1]);
      extraInfo = [0, 1];
      dockSplitHelper.setExtraDockInfo(extraInfo);
      expect(dockSplitHelper.isAllAppsIcon).assertFalse();
      expect(dockSplitHelper.dockAppDirection).assertEqual(extraInfo[0]);
      expect(dockSplitHelper.gestureDockApps).assertEqual(extraInfo[1]);
    });

    it('setDockOnLeft_001', Level.LEVEL0, (): void => {
      let gestureDockParam = SCBGestureDockModel.getInstance().gestureDockParam;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_LEFT_OUT;
      dockSplitHelper.setDockOnLeft();
      expect(dockSplitHelper.isLeftDock).assertTrue();
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_RIGHT_OUT;
      dockSplitHelper.setDockOnLeft();
      expect(dockSplitHelper.isLeftDock).assertFalse();
    });

    it('getDockTranslate_001', Level.LEVEL0, (): void => {
      let dockModel = SCBGestureDockModel.getInstance();
      let gestureDockParam = SCBGestureDockModel.getInstance().gestureDockParam;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_RIGHT_OUT;
      dockSplitHelper.setDockOnLeft();
      expect(dockSplitHelper.isLeftDock).assertFalse();
      expect(dockSplitHelper.getDockDirection()).assertEqual(GestureDockDirection.GESTURE_DOCK_RIGHT);
      expect(dockSplitHelper.getDockTranslate()).assertEqual(dockModel.rightGestureParams.translation);
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_LEFT_OUT;
      dockSplitHelper.setDockOnLeft();
      expect(dockSplitHelper.isLeftDock).assertTrue();
      expect(dockSplitHelper.getDockDirection()).assertEqual(GestureDockDirection.GESTURE_DOCK_LEFT);
      expect(dockSplitHelper.getDockTranslate()).assertEqual(dockModel.leftGestureParams.translation);
    });

    it('getDockDirection_001', Level.LEVEL0, (): void => {
      let gestureDockParam = SCBGestureDockModel.getInstance().gestureDockParam;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_RIGHT_OUT;
      dockSplitHelper.setDockOnLeft();
      expect(dockSplitHelper.isLeftDock).assertFalse();
      expect(dockSplitHelper.getDockDirection()).assertEqual(GestureDockDirection.GESTURE_DOCK_RIGHT);
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_LEFT_OUT;
      dockSplitHelper.setDockOnLeft();
      expect(dockSplitHelper.isLeftDock).assertTrue();
      expect(dockSplitHelper.getDockDirection()).assertEqual(GestureDockDirection.GESTURE_DOCK_LEFT);
    });

    it('setDockIconSize_001', Level.LEVEL0, (): void => {
      let iconSize = AllAppsViewModel.getInstance().getStyleConfig().iconSize;
      dockSplitHelper.isAllAppsIcon = false;
      dockSplitHelper.setDockIconSize();
      expect(dockSplitHelper.dockIconSize).assertEqual(GestureDockConstants.GESTURE_DOCK_ICON_SIZE);
      dockSplitHelper.isAllAppsIcon = true;
      dockSplitHelper.setDockIconSize();
      expect(dockSplitHelper.dockIconSize).assertEqual(iconSize);
    });

    it('moveDock_001', Level.LEVEL0, (): void => {
      dockSplitHelper.dockRect = new SCBSessionRect(0, 0, 100, 100);
      expect(dockSplitHelper.dockRect.contains(200, 0)).assertFalse();
      expect(dockSplitHelper.dockRect.contains(0, 200)).assertFalse();
      expect(dockSplitHelper.dockRect.contains(0, 0)).assertTrue();
      expect(dockSplitHelper.dockRect.contains(0, -1)).assertFalse();
      expect(dockSplitHelper.dockRect.contains(-1, 0)).assertFalse();
      dockSplitHelper.isIconHoverOnDock = true;
      let contains = dockSplitHelper.moveDock(0, 0);
      expect(contains).assertTrue();
      dockSplitHelper.isIconHoverOnDock = false;
      contains = dockSplitHelper.moveDock(0, -1);
      expect(contains).assertFalse();
      dockSplitHelper.isIconHoverOnDock = false;
      contains = dockSplitHelper.moveDock(-1, 0);
      expect(contains).assertFalse();
      dockSplitHelper.isIconHoverOnDock = true;
      contains = dockSplitHelper.moveDock(0, 200);
      expect(contains).assertFalse();
    });

    it('doDockTranslate_001', Level.LEVEL0, (): void => {
      let dockModel = SCBGestureDockModel.getInstance();
      let translate = 10;
      let gestureDockParam = SCBGestureDockModel.getInstance().gestureDockParam;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_RIGHT_OUT;
      dockSplitHelper.setDockOnLeft();
      dockSplitHelper.doDockTranslate(translate);
      expect(dockSplitHelper.isLeftDock).assertFalse();
      expect(dockSplitHelper.getDockDirection()).assertEqual(GestureDockDirection.GESTURE_DOCK_RIGHT);
      expect(dockModel.rightGestureParams.translation).assertEqual(translate);
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_LEFT_OUT;
      dockSplitHelper.setDockOnLeft();
      dockSplitHelper.doDockTranslate(translate);
      expect(dockSplitHelper.isLeftDock).assertTrue();
      expect(dockSplitHelper.getDockDirection()).assertEqual(GestureDockDirection.GESTURE_DOCK_LEFT);
      expect(dockModel.leftGestureParams.translation).assertEqual(translate);
    });

    it('calcWaitTime_001', Level.LEVEL0, (): void => {
      dockSplitHelper.waitTime = 100;
      dockSplitHelper.isIconHoverOnDock = true;
      dockSplitHelper.calcWaitTime();
      expect(dockSplitHelper.waitTime).assertEqual(0);
      dockSplitHelper.isIconHoverOnDock = false;
      dockSplitHelper.curEvent = undefined;
      dockSplitHelper.calcWaitTime();
      expect(dockSplitHelper.waitTime).assertEqual(0);
    });

    it('recordDockScreenProperty_001', Level.LEVEL0, (): void => {
      let screenProperty = new SCBScreenProperty();
      dockSplitHelper.getDockScreenProperty = () => screenProperty;
      let screenId = -1;
      screenProperty.screenId = screenId;
      dockSplitHelper.recordDockScreenProperty();
      expect(dockSplitHelper.screenId).assertEqual(screenId);
    });

    it('resetPositionWithoutAnimation_001', Level.LEVEL0, (): void => {
      let screenProperty = new SCBScreenProperty();
      dockSplitHelper.resetPositionWithoutAnimation(screenProperty);
      let gestureDockParam = SCBGestureDockModel.getInstance().gestureDockParam;
      let leftGestureParams = SCBGestureDockModel.getInstance().leftGestureParams;
      let rightGestureParams = SCBGestureDockModel.getInstance().rightGestureParams;
      expect(leftGestureParams.translation).assertEqual(0);
      expect(leftGestureParams.shadow).assertUndefined();
      expect(rightGestureParams.translation).assertEqual(0);
      expect(rightGestureParams.shadow).assertUndefined();
      expect(gestureDockParam.gestureDockShowMode).assertEqual(GestureDockMode.INVISIBLE);
      expect(gestureDockParam.isGestureDockShow).assertFalse();
      expect(gestureDockParam.gestureDockDirection).assertEqual(GestureDockState.GESTURE_DOCK_IN);
      expect(gestureDockParam.blurRadius).assertEqual(GestureDockConstants.GESTURE_DOCK_BLUR_RADIUS);
    });

    it('setSceneParam_001', Level.LEVEL0, (): void => {
      let spaceSenseParams = new SplitSpaceSenseParams();
      let sceneParam = new SceneParam();
      spaceSenseParams.setSceneParam(sceneParam);
      expect(spaceSenseParams.rotateAngle).assertEqual(sceneParam.rotateAngle);
      expect(spaceSenseParams.rotateCenterX).assertEqual(sceneParam.rotateCenterX);
      expect(spaceSenseParams.rotateCenterY).assertEqual(sceneParam.rotateCenterY);
      expect(spaceSenseParams.rotateX).assertEqual(sceneParam.rotateX);
      expect(spaceSenseParams.rotateY).assertEqual(sceneParam.rotateY);
      expect(spaceSenseParams.rotateZ).assertEqual(sceneParam.rotateZ);
      expect(spaceSenseParams.gradientAngle).assertEqual(sceneParam.gradientAngle);
      expect(spaceSenseParams.gradient1).assertEqual(sceneParam.gradient1);
      expect(spaceSenseParams.gradient2).assertEqual(sceneParam.gradient2);
    });

    it('setInEditMode_001', Level.LEVEL0, (): void => {
      let gestureDockParam = SCBGestureDockModel.getInstance().gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
      dockSplitHelper.setInEditMode();
      expect(dockSplitHelper.isInEditMode).assertTrue();
      gestureDockParam.gestureDockShowMode = GestureDockMode.INVISIBLE;
      dockSplitHelper.setInEditMode();
      expect(dockSplitHelper.isInEditMode).assertFalse();
    });
  });
}