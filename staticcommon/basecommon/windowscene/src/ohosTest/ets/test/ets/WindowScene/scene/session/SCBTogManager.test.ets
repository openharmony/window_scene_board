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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { ReflectionUtils } from '../../utils/ReflectionUtils';
import sceneSessionManager from '@ohos.sceneSessionManager'
import {
  SCBTogManager,
  NotifyPCModeCallback,
  SCBSceneInfo,
  StartFrom,
  SCBSceneContainerSession,
  SCBSceneSession,
  SCBScreenProperty
} from '../../../../../../../..';

import {
  SCBSceneSessionManager,
} from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import { MockUtil } from '../../../../MockUtil';

export function SCBTogManagerTest(){
  let scbTogManager = SCBTogManager.getInstance();
  let tempSceneSessionManager = SCBSceneSessionManager.getInstance();
  SCBSceneSessionManager.getInstance().getScenePersistent().addPersistentExceptList('SCBTogManagerTest01');
  SCBSceneSessionManager.getInstance().getScenePersistent().addPersistentExceptList('SCBTogManagerTest02');
  SCBSceneSessionManager.getInstance().getScenePersistent().addPersistentExceptList('SCBTogManagerTest03');
  describe('SCBTogManagerTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('registerNotifyPCModeCallbackTest01', 0, () => {
      let acallback = null;
      SCBTogManager.getInstance().registerNotifyPCModeCallback(acallback);
      let callback: NotifyPCModeCallback = new NotifyPCModeCallback();
      expect(callback instanceof NotifyPCModeCallback).assertTrue();
      SCBTogManager.getInstance().registerNotifyPCModeCallback(callback);
    });

    it('registerNotifyPCModeCallbackTest02', 0, () => {
      let acallback: NotifyPCModeCallback = new NotifyPCModeCallback();
      SCBTogManager.getInstance().registerNotifyPCModeCallback(acallback);
      SCBTogManager.getInstance().registerNotifyPCModeCallback(acallback);
      expect(acallback instanceof NotifyPCModeCallback).assertTrue();
    });

    it('unregisterNotifyPCModeCallbackTest01', 0, () => {
      let acallback = null;
      SCBTogManager.getInstance().unregisterNotifyPCModeCallback(acallback);
      let callback: NotifyPCModeCallback = new NotifyPCModeCallback();
      expect(callback instanceof NotifyPCModeCallback).assertTrue();
      SCBTogManager.getInstance().unregisterNotifyPCModeCallback(callback);
    });

    it('unregisterNotifyPCModeCallbackTest02', 0, () => {
      let acallback = null;
      SCBTogManager.getInstance().unregisterNotifyPCModeCallback(acallback);
      let callback: NotifyPCModeCallback = new NotifyPCModeCallback();
      expect(callback instanceof NotifyPCModeCallback).assertTrue();
      SCBTogManager.getInstance().unregisterNotifyPCModeCallback(callback);
      SCBTogManager.getInstance().unregisterNotifyPCModeCallback(callback);
    });

    it('unregisterNotifyPCModeCallbackTest03', 0, () => {
      let callback: NotifyPCModeCallback = new NotifyPCModeCallback();
      SCBTogManager.getInstance().registerNotifyPCModeCallback(callback);
      SCBTogManager.getInstance().unregisterNotifyPCModeCallback(callback);
      expect(callback instanceof NotifyPCModeCallback).assertTrue();
    });

    it('onStartSceneTestNull', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
      expect(scbTogManager.onStartScene(sceneInfo, StartFrom.ICON)).assertFalse();
      expect(scbTogManager.onStartScene(null, StartFrom.ICON)).assertFalse();
    });

    it('onStartSceneTestNotSupportPcMode', 0, () => {
      ReflectionUtils.setProperty(tempSceneSessionManager, 'supportPcMode', false);
      expect(scbTogManager.onStartScene(null, null)).assertFalse();
      ReflectionUtils.setProperty(tempSceneSessionManager, 'supportPcMode', true);
    });

    it('onStartSceneTest01', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
      let startFrom: StartFrom = StartFrom.ICON;
      expect(scbTogManager.onStartScene(sceneInfo, startFrom)).assertFalse();
      sceneInfo.bundleName = "SCBTogManagerTest01";
      expect(SCBTogManager.getInstance().onStartScene(sceneInfo,startFrom)).assertFalse();
      startFrom = StartFrom.OTHER;
      expect(SCBTogManager.getInstance().onStartScene(sceneInfo,startFrom)).assertFalse();
    });

    it('onStartSceneTest02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
      let startFrom: StartFrom = StartFrom.ICON;
      expect(scbTogManager.onStartScene(sceneInfo, startFrom)).assertFalse();
      sceneInfo.bundleName = "SCBTogManagerTest02";
      expect(SCBTogManager.getInstance().onStartScene(sceneInfo, startFrom)).assertFalse();
      startFrom = StartFrom.OTHER;
      expect(SCBTogManager.getInstance().onStartScene(sceneInfo, startFrom)).assertFalse();
    });

    it('onStartSceneTest03', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
      let startFrom: StartFrom = StartFrom.TRANSITION;
      expect(scbTogManager.onStartScene(sceneInfo,startFrom)).assertFalse();
      sceneInfo.bundleName = "SCBTogManagerTest03";
      expect(SCBTogManager.getInstance().onStartScene(sceneInfo,startFrom)).assertFalse();
    });

    it('onStartSceneTest04', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
      let startFrom: StartFrom = StartFrom.ICON;
      expect(scbTogManager.onStartScene(sceneInfo,startFrom)).assertFalse();
      sceneInfo.bundleName = "SCBTogManagerTest04";
      expect(SCBTogManager.getInstance().onStartScene(sceneInfo,startFrom)).assertFalse();
    });

    it('tryShowTipsTest01', 0, () => {
      SCBTogManager.getInstance().showTips();
      SCBTogManager.getInstance().clearRecoderSceneInfo();
      expect(SCBTogManager.getInstance().getRecoderSceneInfo()).assertEqual(undefined);
    });

    it('tryHideTipsTest01', 0, () => {
      ReflectionUtils.setProperty(scbTogManager, 'isShowingTips', true);
      SCBTogManager.getInstance().hideTips();
      expect(ReflectionUtils.getProperty(scbTogManager, 'isShowingTips')).assertEqual(false);
      SCBTogManager.getInstance().clearRecoderSceneInfo();
      expect(SCBTogManager.getInstance().getRecoderSceneInfo()).assertEqual(undefined);
    });

    it('isPCFloatTest01', 0, () => {
      SCBTogManager.getInstance().isPCFloat(null);

      let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
      let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
      let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
      testPrimarySCBSceneSession.session.setIsPcAppInPad(testPrimarySCBSceneSession['checkIfPcAppInPad']());
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession, testSCBScreenProperty);
      containerSession.primarySession = new SCBSceneSession(testSession, testSCBSceneInfo);
      containerSession.secondarySession = null;
      containerSession.isSplit = true;
      expect(SCBTogManager.getInstance().isPCFloat(containerSession)).assertFalse();

      containerSession.secondarySession = new SCBSceneSession(testSession, testSCBSceneInfo);
      expect(SCBTogManager.getInstance().isPCFloat(containerSession)).assertFalse();
    });

    it('isPCFloatTest02', 0, () => {
      let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
      let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
      let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
      testPrimarySCBSceneSession.session.setIsPcAppInPad(testPrimarySCBSceneSession['checkIfPcAppInPad']());
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession,testSCBScreenProperty);

      containerSession.isSplit = true;
      containerSession.primarySession = new SCBSceneSession(testSession, testSCBSceneInfo);
      containerSession.secondarySession = new SCBSceneSession(testSession, testSCBSceneInfo);
      expect(SCBTogManager.getInstance().isPCFloat(containerSession)).assertFalse();

      containerSession.secondarySession = null;
      expect(SCBTogManager.getInstance().isPCFloat(containerSession)).assertFalse();
    });

    it('isPCFloatTest03', 0, () => {
      let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
      let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
      let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
      testPrimarySCBSceneSession.session.setIsPcAppInPad(testPrimarySCBSceneSession['checkIfPcAppInPad']());
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession, testSCBScreenProperty);

      containerSession.isSplit = true;
      containerSession.primarySession = null;
      containerSession.secondarySession = null;
      let sceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
      sceneSession.sceneInfo.bundleName = "SCBTogManagerTest01";
      expect(SCBTogManager.getInstance().isPCFloat(containerSession)).assertFalse();

      containerSession.primarySession = new SCBSceneSession(testSession, testSCBSceneInfo);
      containerSession.secondarySession = new SCBSceneSession(testSession, testSCBSceneInfo);
      sceneSession.sceneInfo.bundleName = "SCBTogManagerTest";
      expect(SCBTogManager.getInstance().isPCFloat(containerSession)).assertFalse();
    });

    it('isPCFloatTest04', 0, () => {
      let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
      let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
      let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
      testPrimarySCBSceneSession.session.setIsPcAppInPad(testPrimarySCBSceneSession['checkIfPcAppInPad']());
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession,testSCBScreenProperty);

      containerSession.isSplit = false;
      containerSession.primarySession = new SCBSceneSession(testSession, testSCBSceneInfo);
      MockUtil.mockFuncForObj(scbTogManager, 'checkWhiteList', (): boolean => { return true; });
      expect(SCBTogManager.getInstance().isPCFloat(containerSession)).assertTrue();

      containerSession.primarySession = null;
      expect(SCBTogManager.getInstance().isPCFloat(containerSession)).assertFalse();
    });

    it('isPCFloatTest05', 0, () => {
      let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
      let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
      let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
      testPrimarySCBSceneSession.session.setIsPcAppInPad(testPrimarySCBSceneSession['checkIfPcAppInPad']());
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession,testSCBScreenProperty);

      containerSession.isSplit = false;
      containerSession.primarySession = new SCBSceneSession(testSession, testSCBSceneInfo);
      MockUtil.mockFuncForObj(scbTogManager, 'checkWhiteList', (): boolean => { return false; });
      SCBTogManager.getInstance().isPCFloat(containerSession);
      expect(SCBTogManager.getInstance().isPCFloat(containerSession)).assertFalse();
    });

    it('setRecoderSceneInfTest01', 0, () => {
      ReflectionUtils.setProperty(scbTogManager, 'recoderStartFrom', StartFrom.TRANSITION);
      expect(ReflectionUtils.useFunc(scbTogManager, 'setRecoderSceneInfo', null, StartFrom.TRANSITION));
      expect(ReflectionUtils.getProperty(scbTogManager, 'recoderStartFrom')).assertEqual(StartFrom.TRANSITION);
    });

    it('setRecoderSceneInfTest02', 0, () => {
      let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
      ReflectionUtils.setProperty(scbTogManager, 'recoderStartFrom', StartFrom.TRANSITION);
      expect(ReflectionUtils.useFunc(scbTogManager, 'setRecoderSceneInfo', testSCBSceneInfo, StartFrom.ICON));
      expect(ReflectionUtils.getProperty(scbTogManager, 'recoderStartFrom')).assertEqual(StartFrom.ICON);
    });

    it('setRecoderSceneInfTest03', 0, () => {
      let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
      ReflectionUtils.setProperty(scbTogManager, 'recoderStartFrom', StartFrom.TRANSITION);
      expect(ReflectionUtils.useFunc(scbTogManager, 'setRecoderSceneInfo', testSCBSceneInfo, StartFrom.ICON));
      expect(ReflectionUtils.getProperty(scbTogManager, 'recoderStartFrom')).assertEqual(StartFrom.ICON);
    });

    it('updateRunningPids01', 0, () => {
      expect(ReflectionUtils.useFunc(scbTogManager, 'updateRunningPids', 1));
      expect(ReflectionUtils.useFunc(scbTogManager, 'updateRunningPids', 1));
      expect(ReflectionUtils.useFunc(scbTogManager, 'updateRunningPids', 2));
    });

  })
}
