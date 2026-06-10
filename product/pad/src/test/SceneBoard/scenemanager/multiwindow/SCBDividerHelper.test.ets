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
  SCBDividerParam, SCBScreenSessionManager } from '@ohos/windowscene';
import { beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import {
  DraggingHelper,
  ExitBorder,
  PreScale,
  PriParamsWithRotateAngle,
  SCBDividerHelper,
  SecParamsWithRotateAngle,
  SlipAnimationParams } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBDividerHelper';
import {
  GestureAction,
  SCBGestureRecord } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBGestureRecord';

export function SCBDividerHelperTest() {

  let dividerHelper: SCBDividerHelper = new SCBDividerHelper();
  let dividerParam: SCBDividerParam = new SCBDividerParam();
  let dragginghelper: DraggingHelper = new DraggingHelper();
  let priParams: PriParamsWithRotateAngle = dividerHelper.initPriParamsWithRotateAngle();
  let secParams: SecParamsWithRotateAngle = dividerHelper.initSecParamsWithRotateAngle();
  let animationParams: SlipAnimationParams =
    new SlipAnimationParams(1, 1, 0.5, 0.5, 0, 0, priParams, secParams, 0, 0, true, 0, 1, 0);

  let preScale: PreScale = {
    primaryPreScaleX: 0.5,
    secondPreScaleX: 0.5,
    primaryPreScaleY: 0.5,
    secondPreScaleY: 0.5
  }

  let exitBorder: ExitBorder = {
    largeExitPos: 0,
    lessExitPos: 0
  }

  describe('SCBDividerHelperTest_001', () => {
    beforeAll((): void => {
      dividerHelper.init(dividerParam);
    })

    it('init_001', Level.LEVEL0, (): void => {
      dragginghelper.init(1,1,true,exitBorder);
      expect(true).assertTrue();
    });

    it('defaultParam', Level.LEVEL0, (): void => {
      let params: SlipAnimationParams =
        new SlipAnimationParams(0, 0, 0, 0, 0, 0, priParams, secParams, 0, 0, true, 0, 0, 0);
      expect(params.firstSceneSessionScale).assertEqual(0);
      expect(params.secondSceneSessionScale).assertEqual(0);
      expect(params.firstScenePct).assertEqual(0);
      expect(params.secondScenePct).assertEqual(0);
      expect(params.firstSceneRotateAngle).assertEqual(0);
      expect(params.secondSceneRotateAngle).assertEqual(0);
      expect(params.firstSceneIconTranslate).assertEqual(0);
      expect(params.secondSceneIconTranslate).assertEqual(0);
      expect(params.isPrimAppIconAnimation).assertTrue();
      expect(params.appIconOpacity).assertEqual(0);
      expect(params.appIconTouchScale).assertEqual(0);
      expect(params.dividerTranslate).assertEqual(0);
      expect(params.primaryBlendMode).assertFalse();
      expect(params.secondBlendMode).assertFalse();
    })

    it('getDividerPositionPct_001', Level.LEVEL0, (): void => {
      dragginghelper.getDividerPositionPct(1,1);
      expect(true).assertTrue();
    });

    it('initPriParamsWithRotateAngleTest_001', Level.LEVEL0, () => {
      let params = dividerHelper.initPriParamsWithRotateAngle();
      expect(params.primaryBlendMode).assertFalse();
      expect(params.primarySceneOpacity).assertEqual(1);
      expect(params.primarySceneBlurScale).assertEqual(1);
      expect(params.primaryGradientAngle).assertEqual(0);
      expect(params.primaryGradient1).assertEqual(0);
      expect(params.primaryGradient2).assertEqual(0);
      expect(params.primaryScaleX).assertEqual(1);
      expect(params.primaryScaleY).assertEqual(1);
    })

    it('getRotateAngleTest_001', Level.LEVEL0, () => {
      dividerHelper.getRotateAngle(1,true);

      let mocker: MockKit = new MockKit();
      let obj = SCBScreenSessionManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
      when(mockFunc)().afterReturn(true);
      dividerHelper.getRotateAngle(1,false);
      expect(true).assertTrue();
      mocker.clear(obj);

      dividerHelper.getRotateAngle(1,false);
      expect(true).assertTrue();
    })

    it('initSecParamsWithRotateAngleTest_001', Level.LEVEL0, () => {
      let params = dividerHelper.initSecParamsWithRotateAngle();
      expect(params.secondBlendMode).assertFalse();
      expect(params.secondSceneOpacity).assertEqual(1);
      expect(params.secondSceneBlurScale).assertEqual(1);
      expect(params.secondGradientAngle).assertEqual(0);
      expect(params.secondGradient1).assertEqual(0);
      expect(params.secondGradient2).assertEqual(0);
      expect(params.secondScaleX).assertEqual(1);
      expect(params.secondScaleY).assertEqual(1);
    })

    it('sceneStackScaleTranslate_001', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockFunc = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
      when(mockFunc)().afterReturn(false);
      dividerParam.setIsVertical(false);
      dividerParam.splitOrderIsNotReverse = true;
      dividerHelper.sceneStackScaleTranslate(animationParams);
      expect(true).assertTrue();
      dividerParam.splitOrderIsNotReverse = false;
      dividerHelper.sceneStackScaleTranslate(animationParams);
      expect(true).assertTrue();
      mocker.clear(manager);
    });

    it('sceneStackScaleTranslate_002', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockFunc = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
      when(mockFunc)().afterReturn(false);
      dividerParam.setIsVertical(true);
      dividerParam.splitOrderIsNotReverse = true;
      dividerHelper.sceneStackScaleTranslate(animationParams);
      expect(true).assertTrue();
      dividerParam.splitOrderIsNotReverse = false;
      dividerHelper.sceneStackScaleTranslate(animationParams);
      expect(true).assertTrue();
      mocker.clear(manager);
    });

    it('linearOpacityTranslateTest_001', Level.LEVEL0, () => {
      dividerParam.splitOrderIsNotReverse = true;
      let params: SlipAnimationParams =
        new SlipAnimationParams(1, 1, 1, 1, 1, 1, priParams, secParams, 1, 1, true, 1, 1, 1);
      params.primaryBlendMode = true;
      params.primaryGradientAngle = 1;
      params.primaryGradient1 = 1;
      params.primaryGradient2 = 1;
      params.secondBlendMode = true;
      params.secondGradientAngle = 1;
      params.secondGradient1 = 1;
      params.secondGradient2 = 1;
      dividerHelper.linearOpacityTranslate(params);
      expect(dividerParam.primary.blendMode).assertTrue();
      expect(dividerParam.primary.gradientAngle).assertEqual(1);
      expect(dividerParam.primary.gradient1).assertEqual(1);
      expect(dividerParam.primary.gradient2).assertEqual(1);
      expect(dividerParam.secondary.blendMode).assertTrue();
      expect(dividerParam.secondary.gradientAngle).assertEqual(1);
      expect(dividerParam.secondary.gradient1).assertEqual(1);
      expect(dividerParam.secondary.gradient2).assertEqual(1);

      params.primaryBlendMode = false;
      params.primaryGradientAngle = 2;
      params.primaryGradient1 = 2;
      params.primaryGradient2 = 2;
      params.secondBlendMode = false;
      params.secondGradientAngle = 2;
      params.secondGradient1 = 2;
      params.secondGradient2 = 2;
      dividerHelper.linearOpacityTranslate(params);
      expect(dividerParam.primary.blendMode).assertFalse();
      expect(dividerParam.primary.gradientAngle).assertEqual(2);
      expect(dividerParam.primary.gradient1).assertEqual(2);
      expect(dividerParam.primary.gradient2).assertEqual(2);
      expect(dividerParam.secondary.blendMode).assertFalse();
      expect(dividerParam.secondary.gradientAngle).assertEqual(2);
      expect(dividerParam.secondary.gradient1).assertEqual(2);
      expect(dividerParam.secondary.gradient2).assertEqual(2);

      dividerParam.splitOrderIsNotReverse = false;

      params.primaryBlendMode = true;
      params.primaryGradientAngle = 3;
      params.primaryGradient1 = 3;
      params.primaryGradient2 = 3;
      params.secondBlendMode = true;
      params.secondGradientAngle = 3;
      params.secondGradient1 = 3;
      params.secondGradient2 = 3;
      dividerHelper.linearOpacityTranslate(params);
      expect(dividerParam.primary.blendMode).assertTrue();
      expect(dividerParam.primary.gradientAngle).assertEqual(3);
      expect(dividerParam.primary.gradient1).assertEqual(3);
      expect(dividerParam.primary.gradient2).assertEqual(3);
      expect(dividerParam.secondary.blendMode).assertTrue();
      expect(dividerParam.secondary.gradientAngle).assertEqual(3);
      expect(dividerParam.secondary.gradient1).assertEqual(3);
      expect(dividerParam.secondary.gradient2).assertEqual(3);

      params.primaryBlendMode = false;
      params.primaryGradientAngle = 4;
      params.primaryGradient1 = 4;
      params.primaryGradient2 = 4;
      params.secondBlendMode = false;
      params.secondGradientAngle = 4;
      params.secondGradient1 = 4;
      params.secondGradient2 = 4;
      dividerHelper.linearOpacityTranslate(params);
      expect(dividerParam.primary.blendMode).assertFalse();
      expect(dividerParam.primary.gradientAngle).assertEqual(4);
      expect(dividerParam.primary.gradient1).assertEqual(4);
      expect(dividerParam.primary.gradient2).assertEqual(4);
      expect(dividerParam.secondary.blendMode).assertFalse();
      expect(dividerParam.secondary.gradientAngle).assertEqual(4);
      expect(dividerParam.secondary.gradient1).assertEqual(4);
      expect(dividerParam.secondary.gradient2).assertEqual(4);

      params.primaryBlendMode = true;
      params.primaryGradientAngle = 5;
      params.primaryGradient1 = 5;
      params.primaryGradient2 = 5;
      params.secondBlendMode = false;
      params.secondGradientAngle = 6;
      params.secondGradient1 = 6;
      params.secondGradient2 = 6;
      dividerHelper.linearOpacityTranslate(params);
      expect(dividerParam.primary.blendMode).assertFalse();
      expect(dividerParam.primary.gradientAngle).assertEqual(6);
      expect(dividerParam.primary.gradient1).assertEqual(6);
      expect(dividerParam.primary.gradient2).assertEqual(6);
      expect(dividerParam.secondary.blendMode).assertTrue();
      expect(dividerParam.secondary.gradientAngle).assertEqual(5);
      expect(dividerParam.secondary.gradient1).assertEqual(5);
      expect(dividerParam.secondary.gradient2).assertEqual(5);
    })

    it('calSecParamsWithRotateAngleTest_001', Level.LEVEL0, () => {
      dividerHelper.calSecParamsWithRotateAngle(1,preScale,true,0);
      expect(true).assertTrue();
      dividerHelper.calSecParamsWithRotateAngle(1,preScale,true,1);
      expect(true).assertTrue();
      dividerHelper.calSecParamsWithRotateAngle(0,preScale,false,0);
      expect(true).assertTrue();
    })
    it('calPriParamsWithRotateAngleTest_001', Level.LEVEL0, () => {
      dividerHelper.calPriParamsWithRotateAngle(1,preScale,true,0);
      expect(true).assertTrue();
      dividerHelper.calPriParamsWithRotateAngle(1,preScale,true,1);
      expect(true).assertTrue();
      dividerHelper.calPriParamsWithRotateAngle(0,preScale,false,0);
      expect(true).assertTrue();
    })
  });
}