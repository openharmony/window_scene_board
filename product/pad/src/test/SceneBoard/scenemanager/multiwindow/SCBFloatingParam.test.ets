/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
  CornerArea,
  RecentFloatingAnimParams,
  RecentParams,
  RecordType,
  UserAction,
  CornerParam,
  FloatingRectCache
} from '@ohos/windowscene/src/main/ets/scene/session/SCBFloatingParam';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  ScbNumber,
  SCBSceneContainerSession,
  SCBScreenProperty,
  SCBSceneInfo,
  SCBFloatingParam,
  SCBGestureActionId,
  SCBSceneSession
} from '@ohos/windowscene';
import { RectItem } from '@ohos/basicutils';
import { RotationConstants, } from '@ohos/commonconstants';
import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';

let sceneSessionTmp: SCBSceneSession;
let sceneInfoTmp: SCBSceneInfo;
let containerTmp: SCBSceneContainerSession;
let screenPropTmp: SCBScreenProperty;
let floatParamTmp: SCBFloatingParam;
let rectCacheTmp: FloatingRectCache = new FloatingRectCache(1, 1, 1, 1);
let assertFlag: boolean = true;

export function SCBFloatingParamTest() {
  describe('SCBFloatingParamTest_describe', () => {
    beforeAll(() => {
      screenPropTmp = new SCBScreenProperty();
      screenPropTmp.width = 1260;
      screenPropTmp.height = 2500;
      sceneInfoTmp = new SCBSceneInfo('testSideEdgeBar_bundle', 'testSideEdgeBar_module', 'testSideEdgeBar_ability');
      sceneSessionTmp = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoTmp), sceneInfoTmp);
      containerTmp = new SCBSceneContainerSession(sceneSessionTmp, screenPropTmp);
      floatParamTmp = new SCBFloatingParam();
      containerTmp.floatingParam = floatParamTmp;
    })
    SCBFloatingParamTest_01_func();
    SCBFloatingParamTest_copyFrom_func();
    SCBFloatingParamTest_copyTo_func();
    SCBFloatingParamTest_setFloatingRect_func();
    SCBFloatingParamTest_setMemValue02_func();
    SCBFloatingParamTest_setMemValue01_func();
    SCBFloatingParamTest_initWithDeviceInfo_func();
    SCBFloatingParamTest_recordRect_func();
    SCBFloatingParamTest_recentFloatingAnimParams_func();
    SCBFloatingParamTest_isVertical_func();
  })
}

function SCBFloatingParamTest_01_func() {
  it('SCBFloatingParamTest_initCacheForMini_it', Level.LEVEL0, (): void => {
    floatParamTmp.initCacheForMini();
    floatParamTmp.getRotationOnExpandStatus(screenPropTmp);
    floatParamTmp.setBorderColor('000000FF');
    floatParamTmp.setBorderColor('00FF0000');
    floatParamTmp.setFloatingSceneClosed(true);
    floatParamTmp.setFloatingSceneClosed(false);
    floatParamTmp.setFloatingSceneClosed(true);
    floatParamTmp.isClosed = true;
    floatParamTmp.isClosed = false;
    floatParamTmp.isTerminated = false;
    floatParamTmp.isTerminated = true;
    let result: boolean = floatParamTmp.isFloatingSceneClosed();
    let userAction: UserAction = floatParamTmp.getUserAction();
    floatParamTmp.setUserAction(userAction);
    floatParamTmp.setUserAction(UserAction.QUICK_MIN);
    userAction = floatParamTmp.getUserAction();
    let transformCallbackTmp = (id?: SCBGestureActionId) => {
      id = 1;
    }
    floatParamTmp.notifyTransform();
    floatParamTmp.registerTransformCallback(transformCallbackTmp);
    floatParamTmp.notifyTransform();
    floatParamTmp.unregisterTransformCallback(transformCallbackTmp);
    floatParamTmp.notifyTransform();
    floatParamTmp.setFloatEdgeDrag(true);
    expect(assertFlag).assertTrue();
  });
}

function SCBFloatingParamTest_copyFrom_func() {
  it('SCBFloatingParamTest_copyFrom_it', Level.LEVEL0, (): void => {
    let containerWithNullTmp: SCBSceneContainerSession | undefined = undefined;
    containerTmp.floatingParam.recentParams.copyFrom(containerTmp);
    expect(assertFlag).assertTrue();
    containerTmp.floatingParam.recentParams.copyFrom(containerWithNullTmp);
    expect(containerTmp === null).assertFalse();
  });
}

function SCBFloatingParamTest_copyTo_func() {
  it('SCBFloatingParamTest_copyCachedPosition_it', Level.LEVEL0, (): void => {
    let rectTmp: RectItem = new RectItem(1, 1, screenPropTmp.width, screenPropTmp.height);
    containerTmp.floatingParam.recentParams.copyCachedPosition(rectTmp);
    expect(containerTmp === null).assertFalse();
  });

  it('SCBFloatingParamTest_copyTo_it', Level.LEVEL0, (): void => {
    let containerWithNullTmp: SCBSceneContainerSession | undefined = undefined;
    containerTmp.floatingParam.recentParams.copyTo(containerWithNullTmp);
    expect(assertFlag).assertTrue();
    containerTmp.floatingParam.recentParams.copyTo(containerTmp);
    expect(containerTmp === null).assertFalse();
  });
}

function SCBFloatingParamTest_setFloatingRect_func() {
  it('SCBFloatingParamTest_setFloatingRect_it', Level.LEVEL0, (): void => {
    let newRectTmp: FloatingRectCache = new FloatingRectCache(1, 1, 1, 1);
    newRectTmp.scale = 0.6;
    newRectTmp.isMiniScene = false;
    rectCacheTmp.setFloatingRect(newRectTmp);
    expect(rectCacheTmp.scale === 0.6).assertTrue();
    newRectTmp = new FloatingRectCache(0, 0, screenPropTmp.width, screenPropTmp.height);
    newRectTmp.scale = 1;
    newRectTmp.isMiniScene = true;
    rectCacheTmp.setFloatingRect(newRectTmp);
    expect(rectCacheTmp.width() === screenPropTmp.width).assertTrue();
  });
}

function SCBFloatingParamTest_setMemValue02_func() {
  it('SCBFloatingParamTest_setMemValue_it_02', Level.LEVEL0, (): void => {
    let cornerParamTmp: CornerParam = new CornerParam();
    floatParamTmp.shadowOptions = {
      radius: 21,
      type: ShadowType.COLOR,
      color: Color.Gray,
      offsetX: 51,
      offsetY: 51,
      fill: false
    };
    cornerParamTmp.area = CornerArea.MAIN;
    floatParamTmp.cornerParam = cornerParamTmp;
    floatParamTmp.recentParams = new RecentParams();
    floatParamTmp.recentParams.isValid = true;
    floatParamTmp.recentParams.scaleX = new ScbNumber(0.6);
    floatParamTmp.recentParams.scaleY = new ScbNumber(0.6);
    floatParamTmp.recentParams.width = new ScbNumber(screenPropTmp.width);
    floatParamTmp.recentParams.height = new ScbNumber(screenPropTmp.height);
    floatParamTmp.recentParams.positionX = new ScbNumber(120);
    floatParamTmp.recentParams.positionY = new ScbNumber(220);
    cornerParamTmp.anotherSceneRectVp = new RectItem(1, 1, screenPropTmp.width, screenPropTmp.height);
    floatParamTmp.recentParams.clipWidth = new ScbNumber(screenPropTmp.width);
    floatParamTmp.recentParams.clipHeight = new ScbNumber(screenPropTmp.height);
    floatParamTmp.recentParams.floatBorderWidth = 2;
    floatParamTmp.recentParams.floatScale = 0.6;
    floatParamTmp.recentParams.floatBorderRadius = 20;
    floatParamTmp.recentParams.floatShadowColor = '#74000000';
    floatParamTmp.recentParams.isFloatingSessionClosed = false;

    expect(floatParamTmp.recentParams.isValid).assertTrue();
  });
}

function SCBFloatingParamTest_setMemValue01_func() {
  it('SCBFloatingParamTest_setMemValue_it_01', Level.LEVEL0, (): void => {

    floatParamTmp.needShowBackground = false;
    floatParamTmp.floatingScaleHelper = 0.8;
    floatParamTmp.defaultWidthRatio = 0.6;
    floatParamTmp.aspectRatio = 3 / 4;
    floatParamTmp.maxWidthRatio = 0.8;
    floatParamTmp.miniWidthRatio = 0.2;
    floatParamTmp.scale = 0.2;
    floatParamTmp.borderColor = '#00317af6';
    floatParamTmp.borderWidth = 3;
    floatParamTmp.calcRatioBaseWidth = 1260;
    floatParamTmp.aspectWithTitleBar = 3.5 / 4.3;
    floatParamTmp.showSideBarCover = false;
    floatParamTmp.highLightBarOffsetX = 1;
    floatParamTmp.sideBarAlpha = 1;
    floatParamTmp.touchable = false;
    floatParamTmp.floatRecentAnimateFinished = false;
    floatParamTmp.cacheScaleForMini = 1;
    floatParamTmp.miniSceneTopMargin = 32;
    floatParamTmp.miniSceneRightMargin = 20;
    floatParamTmp.cornerRadius = 22;
    floatParamTmp.cacheRect = new RectItem(1, 1, 1, 1);
    floatParamTmp.boardOpacity = 1;
    floatParamTmp.minAnimationNum = 1;
    floatParamTmp.isFloatDragging = false;
    floatParamTmp.needFloatScale = false;
    floatParamTmp.isShowTitleBar = false;
    floatParamTmp.isFloatEdgeDrag = false;
    floatParamTmp.needEffectComponent = false;
    floatParamTmp.isFocused = false;
    floatParamTmp.isClosed = false;
    floatParamTmp.isTerminated = false;
    floatParamTmp.isMinimized = false;
    floatParamTmp.doFoldOrExpand = false;
    floatParamTmp.isMinFloating = false;
    floatParamTmp.isClosingFloat = false;
    floatParamTmp.titleBarOpacity = 1;
    floatParamTmp.transitionAnimationCount = 1;
    floatParamTmp.isLandscapeFloat = false;
    floatParamTmp.isHandleTouchEvent = false;
    floatParamTmp.isInFullHotspot = false;
    floatParamTmp.needRecoverStatusBar = false;
    floatParamTmp.effectCompOpacity = 1;
    expect(assertFlag).assertTrue();
  });
}

function SCBFloatingParamTest_initWithDeviceInfo_func() {
  it('SCBFloatingParamTest_initWithDeviceInfo_it', Level.LEVEL0, (): void => {
    screenPropTmp.width = 1260;
    screenPropTmp.height = 2500;
    floatParamTmp.calcRatioBaseWidth = 1260;
    floatParamTmp.defaultWidthRatio = 0.79;
    floatParamTmp.defaultWidthRatio = 0.8;
    floatParamTmp.initWithDeviceInfo(screenPropTmp, true, false);
    floatParamTmp.initWithDeviceInfo(screenPropTmp, true, true);
    floatParamTmp.initWithDeviceInfo(screenPropTmp, false, false);
    floatParamTmp.initWithDeviceInfo(screenPropTmp, false, true);
    expect(assertFlag).assertTrue();
    let newScreenPropertyTmp = new SCBScreenProperty();
    floatParamTmp.initWithDeviceInfo(newScreenPropertyTmp, true, false);
    floatParamTmp.initWithDeviceInfo(newScreenPropertyTmp, true, true);
    floatParamTmp.initWithDeviceInfo(newScreenPropertyTmp, false, false);
    floatParamTmp.initWithDeviceInfo(newScreenPropertyTmp, false, true);
    expect(assertFlag).assertTrue();
  });
}

function SCBFloatingParamTest_recordRect_func() {
  it('SCBFloatingParamTest_recordRect_it', Level.LEVEL0, (): void => {
    let recordRectTmp = new FloatingRectCache(0, 0, screenPropTmp.width, screenPropTmp.height);
    floatParamTmp.recordRect(recordRectTmp, RecordType.QUICK_CLOSE);
    floatParamTmp.delRecordRect(RecordType.QUICK_CLOSE);
    floatParamTmp.delRecordRect();
    floatParamTmp.recordRect(recordRectTmp, RecordType.AVOID_CACHE);
    floatParamTmp.checkRecordByType(RecordType.AVOID_CACHE);
    floatParamTmp.getRectRecordByType(RecordType.AVOID_CACHE);
    expect(assertFlag).assertTrue();
  });
}

function SCBFloatingParamTest_recentFloatingAnimParams_func() {
  it('SCBFloatingParamTest_recentFloatingAnimParams_it', Level.LEVEL0, (): void => {
    let positionXTmp: number = 0;
    let positionYTmp: number = 0;
    let widthTmp: number = 0;
    let persistentIdTmp: number = 2;
    let floatAnimTmp: RecentFloatingAnimParams = new RecentFloatingAnimParams(persistentIdTmp, positionXTmp,
      positionYTmp, widthTmp);
    let posXNumber: number = floatAnimTmp.getPositionX();
    let posYNumber: number = floatAnimTmp.getPositionY();
    expect(posXNumber).assertEqual(0);
    expect(posYNumber).assertEqual(0);
    let widthNumber: number = floatAnimTmp.getWidth();
    let PersistentIdNumber: number = floatAnimTmp.getPersistentId();
    expect(widthNumber).assertEqual(0);
    expect(PersistentIdNumber).assertEqual(2);
  });
}

function SCBFloatingParamTest_isVertical_func() {
  it('SCBFloatingParamTest_isVertical', Level.LEVEL0, (): void => {
    floatParamTmp.isVertical(RotationConstants.ROTATION_0);
    floatParamTmp.isVertical(RotationConstants.ROTATION_90);
    floatParamTmp.isVertical(RotationConstants.ROTATION_180);
    floatParamTmp.isVertical(RotationConstants.ROTATION_270);
    floatParamTmp.isVertical(RotationConstants.ROTATION_360);
    expect(assertFlag).assertTrue();
  });
}