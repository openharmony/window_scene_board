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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium'
import screenSessionManager from '@ohos.screenSessionManager';
import {
  SCBScreenProperty,
  SCBScreenSession,
  SCBScreenSessionManager,
  SCBSplitParam
} from '../../../../../../../main/ets/TsIndex';
import { SplitLifeCycle } from '../../../../../../../main/ets/scene/session/SCBSplitParam';
import ServiceExtensionContext from 'application/ServiceExtensionContext';

const DEFAULT: number = 0;

export function SCBSplitParamTest() {

  let splitParam: SCBSplitParam = new SCBSplitParam();
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();

  describe('SCBCommonSplitParamTest', (): void => {
    beforeAll((): void => {
      splitParam.init();
    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    it('initTest', DEFAULT, () => {
      splitParam.needShowTitleBar = false;
      splitParam.oneStepExitNeedAnimation = false;
      splitParam.isPreSplit = true;
      splitParam.showInputMethodFlag = 0;
      splitParam.needShowExitSplitToastForFolded = true;
      splitParam.increNeedDelayRotation();
      splitParam.hasAvoidInputMethod = false;
      splitParam.init();
      expect(splitParam.needShowTitleBar).assertTrue();
      expect(splitParam.oneStepExitNeedAnimation).assertTrue();
      expect(splitParam.isPreSplit).assertFalse();
      expect(splitParam.showInputMethodFlag).assertEqual(1);
      expect(splitParam.needShowExitSplitToastForFolded).assertFalse();
      expect(splitParam.hasAvoidInputMethod).assertFalse();
    })

    it("setLifeCycleTest", DEFAULT, () => {
      splitParam.setLifeCycle(SplitLifeCycle.UNDEFINED);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.UNDEFINED);
      splitParam.setLifeCycle(SplitLifeCycle.EXIT_FULLSCREEN_TO_ONESTEP);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.EXIT_FULLSCREEN_TO_ONESTEP);
      splitParam.setLifeCycle(SplitLifeCycle.ONESTEP);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.ONESTEP);
      splitParam.setLifeCycle(SplitLifeCycle.EXIT_ONESTEP_TO_SPLIT);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.EXIT_ONESTEP_TO_SPLIT);
      splitParam.setLifeCycle(SplitLifeCycle.SPLIT);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.SPLIT);
      splitParam.setLifeCycle(SplitLifeCycle.EXIT_SPLIT_TO_ONESTEP);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.EXIT_SPLIT_TO_ONESTEP);
      splitParam.setLifeCycle(SplitLifeCycle.EXIT_ONESTEP_TO_FUSCREEN);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.EXIT_ONESTEP_TO_FUSCREEN);
      splitParam.setLifeCycle(SplitLifeCycle.EXIT_SPLIT_TO_FULLSCREEN);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.EXIT_SPLIT_TO_FULLSCREEN);
      splitParam.setLifeCycle(SplitLifeCycle.EXIT_SPLIT_TO_FLOATING);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.EXIT_SPLIT_TO_FLOATING);
      splitParam.setLifeCycle(SplitLifeCycle.EXIT_ONESTEP_TO_MIDSCENE);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.EXIT_ONESTEP_TO_MIDSCENE);
      splitParam.setLifeCycle(SplitLifeCycle.EXIT_SPLIT_TO_MIDSCENE);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.EXIT_SPLIT_TO_MIDSCENE);
      splitParam.setLifeCycle(SplitLifeCycle.EXIT_MIDSCENE_TO_SPLIT);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.EXIT_MIDSCENE_TO_SPLIT);

      splitParam.setLifeCycle(SplitLifeCycle.EXIT_SPLIT_TO_ONESTEP);
      splitParam.setLifeCycle(SplitLifeCycle.SPLIT);
      expect(splitParam.getLifeCycle()).assertEqual(SplitLifeCycle.EXIT_SPLIT_TO_ONESTEP);
    })

    it('needDelayRotationTest', DEFAULT, () => {
      let needDelayRotation: number = splitParam.getNeedDelayRotation();
      splitParam.increNeedDelayRotation();
      expect(splitParam.getNeedDelayRotation()).assertEqual(needDelayRotation + 1);

      splitParam.decreNeedDelayRotation();
      expect(splitParam.getNeedDelayRotation()).assertEqual(needDelayRotation);
    })

    it('compareOnTouchRotationTest', DEFAULT, () => {
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {
        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {
        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage | undefined): void => {
        },
        getScreenUIContext: (): UIContext => {
          throw new Error('Function not implemented.');
        }
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      splitParam.onTouchRotation = -1;
      when(getScreenSession)().afterReturn(null);
      screenProperty.screenId = screenSession.screenId;
      splitParam.setOnTouchRotation(screenProperty);
      expect(splitParam.onTouchRotation).assertEqual(screenProperty.rotation);
      when(getScreenSession)().afterReturn(scbScreenSession);
      scbScreenSession.sensorScreenProperty = screenProperty;
      splitParam.setOnTouchRotation(screenProperty);
      expect(splitParam.onTouchRotation).assertEqual(screenProperty.rotation);
      let isSame = splitParam.compareOnTouchRotation(screenProperty);
      expect(isSame).assertTrue();
      mocker.clear(screenSessionManager);
      mocker.clear(getScreenSession);
    })

    it('increNeedDelayRotationTest', DEFAULT, () => {
      let needDelayRotation = splitParam.getNeedDelayRotation();
      splitParam.increNeedDelayRotation();
      expect(splitParam.getNeedDelayRotation()).assertEqual(needDelayRotation + 1);
      splitParam.increNeedDelayRotation();
      expect(splitParam.getNeedDelayRotation()).assertEqual(needDelayRotation + 2);
    })

    it('decreNeedDelayRotationTest', DEFAULT, () => {
      let needDelayRotation = splitParam.getNeedDelayRotation();
      splitParam.decreNeedDelayRotation();
      expect(splitParam.getNeedDelayRotation()).assertEqual(needDelayRotation - 1);
      splitParam.decreNeedDelayRotation();
      expect(splitParam.getNeedDelayRotation()).assertEqual(needDelayRotation - 2);
    })
  })
}