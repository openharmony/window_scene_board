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

import { beforeAll, beforeEach, describe, it, Level, expect, MockKit, ArgumentMatchers, when } from '@ohos/hypium';
import {
  ScbNumber,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneMode,
  SCBSceneOrientation,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSessionRect,
  SCBSpecificSession
} from '@ohos/windowscene';
import { SCBFoldSceneStateManager } from '../../../../../../Index';
import { SCBSceneHelper } from '../../../../../main/ets/utils/SCBSceneHelper';

let scene: SCBSceneSession;
let specificScene: SCBSpecificSession;
let container: SCBSceneContainerSession;
let screenProperty: SCBScreenProperty;
let nullScene: SCBSceneSession;
let testContainer: SCBSceneContainerSession;
let testPrimarySession: SCBSceneSession;
let testSecondarySession: SCBSceneSession;

export function SCBSceneHelperTest() {
  describe('SCBSceneHelperTest', () => {
    beforeAll(() => {
      initTestScreenProperty();
      initTestContainerAndScene();
    });
    beforeEach(() => {
      initTestPriAndSecSession();
    })
    preHandleSubSessionRectClearSceneTest();
    setSceneTranslateTest();
    setSceneScaleTest();
    setSceneOpacityTest();
    resetWindowPosAndScaleTest();
    getDpiTest();
    nearEqualTest();
    setSplitGravityTest();
    isOnlyPortraitTest();
    updateSceneSafeRectTest();
    getRectLogInfoTest();
    querySubSessionOfMainTest();
    resetAllAnimateParamTest();
    updateLastDpiTest();
  });
}

function initTestScreenProperty() {
  screenProperty= new SCBScreenProperty();
  screenProperty.screenId = 100;
  screenProperty.width = 1920;
  screenProperty.height = 1080;
}

function initTestContainerAndScene() {
  let sceneManager = SCBSceneSessionManager.getInstance();
  let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundle1', 'module1', 'ability1');
  let testSession = sceneManager.requestSceneSession(testSCBSceneInfo);
  scene = new SCBSceneSession(testSession, testSCBSceneInfo);
  container = new SCBSceneContainerSession(scene, screenProperty);
  let specificSceneInfo: SCBSceneInfo =
    new SCBSceneInfo('testSpecificBundle', 'testSpecificModule', 'testSpecificAbility');
  specificScene = new SCBSpecificSession(sceneManager.requestSceneSession(specificSceneInfo), () => {});
}

function initTestPriAndSecSession() {
  let sceneManager = SCBSceneSessionManager.getInstance();
  let priSceneInfo = new SCBSceneInfo('testPriBundle1', 'testPriModule1', 'testPriAbility1');
  testPrimarySession = new SCBSceneSession(sceneManager.requestSceneSession(priSceneInfo), priSceneInfo);
  let secSceneInfo = new SCBSceneInfo('testSecBundle2', 'testSecModule2', 'testSecAbility2');
  testSecondarySession = new SCBSceneSession(sceneManager.requestSceneSession(secSceneInfo), secSceneInfo);
  testContainer = new SCBSceneContainerSession(testPrimarySession, screenProperty);
}

function preHandleSubSessionRectClearSceneTest() {
  it('preHandleSubSessionRectClearSceneTest_01', Level.LEVEL0, (): void => {
    const testWidth: ScbNumber = new ScbNumber(100);
    const testHeight: ScbNumber = new ScbNumber(200);
    specificScene.currRect.setRect(new ScbNumber(0), new ScbNumber(0), testWidth, testHeight);
    SCBSceneHelper.preHandleSubSessionRectClearScene(specificScene, screenProperty);
    expect(specificScene.currRect.width.getVp()).assertEqual(testWidth.getVp());
    expect(specificScene.currRect.height.getVp()).assertEqual(testHeight.getVp());
  });
  it('preHandleSubSessionRectClearSceneTest_02', Level.LEVEL0, (): void => {
    const testWidth: ScbNumber = new ScbNumber(0);
    const testHeight: ScbNumber = new ScbNumber(0);
    const screenWidth: ScbNumber = new ScbNumber(screenProperty.width);
    const screenHeight: ScbNumber = new ScbNumber(screenProperty.height);
    specificScene.currRect.setRect(new ScbNumber(0), new ScbNumber(0), testWidth, testHeight);
    SCBSceneHelper.preHandleSubSessionRectClearScene(specificScene, screenProperty);
    expect(specificScene.currRect.width.getVp()).assertEqual(screenWidth.getVp());
    expect(specificScene.currRect.height.getVp()).assertEqual(screenHeight.getVp());
  });
}

function setSceneTranslateTest() {
  it('setSceneTranslateTest_01', Level.LEVEL0, () => {
    let ret = SCBSceneHelper.setSceneTranslate(undefined, 20, 20);
    expect(ret).assertFalse();
  });
  it('setSceneTranslateTest_02', Level.LEVEL0, () => {
    let ret = SCBSceneHelper.setSceneTranslate(specificScene, 20, 30);
    expect(ret).assertTrue();
    expect(specificScene.translateX).assertEqual(20);
    expect(specificScene.translateY).assertEqual(30);
  });
  it('setSceneTranslateTest_03', Level.LEVEL0, () => {
    let ret = SCBSceneHelper.setSceneTranslate(container, 20, 30);
    expect(ret).assertTrue();
    expect(scene.translateX).assertEqual(20);
    expect(scene.translateY).assertEqual(30);
    expect(container.dividerParam.dividerTranslateX).assertEqual(20);
    expect(container.dividerParam.dividerTranslateY).assertEqual(30);
  });
}

function setSceneScaleTest() {
  it('setSceneScaleTest_01', Level.LEVEL0, () => {
    let ret = SCBSceneHelper.setSceneScale(undefined, 2);
    expect(ret).assertFalse();
  });
  it('setSceneScaleTest_02', Level.LEVEL0, () => {
    let ret = SCBSceneHelper.setSceneScale(specificScene, 2);
    expect(ret).assertTrue();
    expect(specificScene.scaleX).assertEqual(2);
    expect(specificScene.scaleY).assertEqual(2);
  });
  it('setSceneScaleTest_03', Level.LEVEL0, () => {
    let ret = SCBSceneHelper.setSceneScale(container, 2);
    expect(ret).assertTrue();
    expect(scene.scaleX).assertEqual(2);
    expect(scene.scaleY).assertEqual(2);
    expect(container.dividerParam.scaleX).assertEqual(2);
    expect(container.dividerParam.scaleY).assertEqual(2);
  });
}

function setSceneOpacityTest() {
  it('setSceneOpacityTest_01', Level.LEVEL0, () => {
    SCBSceneHelper.setSceneOpacity(undefined, 0.1);
    expect(scene !== null).assertTrue();
  });
  it('setSceneOpacityTest_02', Level.LEVEL0, () => {
    SCBSceneHelper.setSceneOpacity(specificScene, 0.1);
    expect(specificScene.opacity).assertEqual(0.1);
  });
  it('setSceneOpacityTest_03', Level.LEVEL0, () => {
    SCBSceneHelper.setSceneOpacity(container, 0.1);
    expect(scene.opacity).assertEqual(0.1);
  });
}

function resetWindowPosAndScaleTest() {
  it('resetWindowPosAndScaleTest_01', Level.LEVEL0, () => {
    SCBSceneHelper.resetWindowPosAndScale(nullScene);
    expect(scene !== null).assertTrue();
  });
  it('resetWindowPosAndScaleTest_02', Level.LEVEL0, () => {
    SCBSceneHelper.resetWindowPosAndScale(scene);
    let sessionDataInner: ESObject = Reflect.get(scene, 'sessionDataInner');
    expect(sessionDataInner.windowOffsetX).assertEqual(0);
    expect(sessionDataInner.windowOffsetY).assertEqual(0);
  });
}

function getDpiTest() {
  it('getDpiTest_01', Level.LEVEL1, () => {
    SCBSceneHelper.getDpi();
    expect(scene !== null).assertTrue();
    SCBSceneHelper.getDpi(0);
    expect(scene !== null).assertTrue();
  });
}

function nearEqualTest() {
  it('nearEqualTest_01', Level.LEVEL0, () => {
    let ret = SCBSceneHelper.nearEqual(1.0, 1.0);
    expect(ret).assertTrue();
  });
  it('nearEqualTest_02', Level.LEVEL0, () => {
    let ret = SCBSceneHelper.nearEqual(1.0, 1.1);
    expect(ret).assertFalse();
  });
}

function setSplitGravityTest() {
  it('setSplitGravityTest_01', Level.LEVEL0, () => {
    container.dividerParam.isSplitPrimaryMode = false;
    SCBSceneHelper.setSplitGravity(container);
    expect(scene !== null).assertTrue();
  });
  it('setSplitGravityTest_02', Level.LEVEL0, () => {
    container.dividerParam.isSplitPrimaryMode = true;
    SCBSceneHelper.setSplitGravity(container);
    expect(scene !== null).assertTrue();
  });
}

function isOnlyPortraitTest() {
  it('isOnlyPortraitTest_01', Level.LEVEL0, () => {
    let ret = SCBSceneHelper.isOnlyPortrait(nullScene);
    expect(ret).assertFalse();
  });
  it('isOnlyPortraitTest_02', Level.LEVEL0, () => {
    let mocker = new MockKit();
    let sceneManager = SCBSceneSessionManager.getInstance();
    let func = mocker.mockFunc(sceneManager, sceneManager.getAbilityOrientation);
    when(func)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.VERTICAL);
    let ret = SCBSceneHelper.isOnlyPortrait(scene);
    expect(ret).assertTrue();
    mocker.clear(sceneManager);
  });
  it('isOnlyPortraitTest_03', Level.LEVEL0, () => {
    let mocker = new MockKit();
    let sceneManager = SCBSceneSessionManager.getInstance();
    let func = mocker.mockFunc(sceneManager, sceneManager.getAbilityOrientation);
    when(func)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.HORIZONTAL);
    let ret = SCBSceneHelper.isOnlyPortrait(scene);
    expect(ret).assertFalse();
    mocker.clear(sceneManager);
  });
}

function updateSceneSafeRectTest() {
  it('updateSceneSafeRectTest_01',  Level.LEVEL0, () => {
    let mocker = new MockKit();
    mocker.mockFunc(scene, scene.setWindowLastSafeRect);
    SCBSceneHelper.updateSceneSafeRect(scene);
    mocker.verify('setWindowLastSafeRect',[,,,]).once();
    mocker.clear(scene);
  });
}

function getRectLogInfoTest() {
  it('getRectLogInfoTest_01',  Level.LEVEL0, () => {
    let rect: SCBSessionRect = new SCBSessionRect(1, 2, 3, 4);
    let logInfo = SCBSceneHelper.getRectLogInfo(rect);
    expect(logInfo).assertEqual('[1, 2, 3, 4]');
  });
}

function querySubSessionOfMainTest() {
  it('querySubSessionOfMainTest_01', Level.LEVEL0, () => {
    let resultList = SCBSceneHelper.querySubSessionOfMain(testContainer);
    expect(resultList.length).assertEqual(0);
  });
  it('querySubSessionOfMainTest_02', Level.LEVEL0, () => {
    testContainer.primarySession = testPrimarySession;
    let resultList = SCBSceneHelper.querySubSessionOfMain(testContainer);
    expect(resultList.length).assertEqual(0);
  });
  it('querySubSessionOfMainTest_03', Level.LEVEL0, () => {
    testContainer.primarySession = testPrimarySession;
    let dialogSceneList: SCBSpecificSession[] = [];
    dialogSceneList.push(specificScene);
    testContainer.primarySession.subSessionList.push(...dialogSceneList);
    let resultList = SCBSceneHelper.querySubSessionOfMain(testContainer);
    expect(resultList.length).assertEqual(1);
  });
  it('querySubSessionOfMainTest_04', Level.LEVEL0, () => {
    testContainer.primarySession = testPrimarySession;
    testContainer.secondarySession = testSecondarySession;
    testContainer.isSplit = true;
    let resultList = SCBSceneHelper.querySubSessionOfMain(testContainer);
    expect(resultList.length).assertEqual(0);
  });
  it('querySubSessionOfMainTest_05', Level.LEVEL0, () => {
    testContainer.primarySession = testPrimarySession;
    testContainer.secondarySession = testSecondarySession;
    testContainer.isSplit = true;
    let dialogSceneList: SCBSpecificSession[] = [];
    dialogSceneList.push(specificScene);
    testContainer.secondarySession.subSessionList.push(...dialogSceneList);
    let resultList = SCBSceneHelper.querySubSessionOfMain(testContainer);
    expect(resultList.length).assertEqual(1);
  });
}

function resetAllAnimateParamTest() {
  it('resetAnimateParamTest_01', Level.LEVEL0, () => {
    testContainer.dividerParam.dividerOpacity = 0;
    SCBSceneHelper.resetAnimateParam(testContainer);
    expect(testContainer.dividerParam.dividerOpacity).assertEqual(1);
  });
  it('resetAnimateParamTest_02', Level.LEVEL0, () => {
    SCBSceneHelper.resetAnimateParam(testContainer);
    expect(testContainer.dividerParam.dividerTranslateX).assertEqual(0);
    expect(testContainer.dividerParam.dividerTranslateY).assertEqual(0);
    expect(testContainer.dividerParam.scaleX).assertEqual(1);
    expect(testContainer.dividerParam.scaleY).assertEqual(1);
    expect(testContainer.dividerParam.dividerOpacity).assertEqual(1);
  });
  it('resetAnimateParamTest_03', Level.LEVEL0, () => {
    testContainer.primarySession = testPrimarySession;
    testContainer.secondarySession = testSecondarySession;
    let dialogSceneList: SCBSpecificSession[] = [];
    dialogSceneList.push(specificScene);
    testContainer.primarySession.dialogSessionList.push(...dialogSceneList);
    SCBSceneHelper.resetAnimateParam(testContainer);
    expect(testContainer.primarySession.dialogSessionList[0]?.translateX).assertEqual(0);
    expect(testContainer.primarySession.dialogSessionList[0]?.translateY).assertEqual(0);
    expect(testContainer.primarySession.dialogSessionList[0]?.scaleX).assertEqual(1);
    expect(testContainer.primarySession.dialogSessionList[0]?.scaleY).assertEqual(1);
    expect(testContainer.primarySession.dialogSessionList[0]?.opacity).assertEqual(1);
  });
}

function updateLastDpiTest() {
  it('updateLastDpiTest_01', Level.LEVEL0, () => {
    scene.sessionData.lastDpi = 200;
    SCBSceneHelper.updateLastDpi(scene, 50);
    expect(scene.sessionData.lastDpi).assertEqual(50);
  });
  it('updateLastDpiTest_02', Level.LEVEL0, () => {
    scene.sessionData.lastDpi = 50;
    SCBSceneHelper.updateLastDpi(scene, 50);
    expect(scene.sessionData.lastDpi).assertEqual(50);
  });
}