/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
  ArgumentMatchers,
  MockKit,
  when,
} from '@ohos/hypium';
import { SCBPropertyChangeReason, SCBScreenProperty, SCBScreenSession } from '@ohos/windowscene';
import screenSessionManager from '@ohos.screenSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBWindowRotate } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/SCBWindowRotate';
import { ReflectionUtils } from './multiwindow/ReflectionUtils';

const TAG = 'SCBWindowRotateTest';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

let windowRotate: SCBWindowRotate = SCBWindowRotate.getInstance();
let mocker = new MockKit();

export function SCBWindowRotateTest() {
  describe('Product_SCBWindowRotateTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      windowRotate.getRotateAnimationCnt()
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('callNotifyScreenRotateToCallbacksTwice', 0, () => {
      // notifyScreenRotateToCallbacks
      let func1 = mocker.mockFunc(windowRotate, windowRotate.notifyScreenRotateToCallbacks);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithNoAnimation notifyScreenRotateToCallbacks action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithNoAnimation(windowRotate);
      // verify
      expect(count).assertEqual(2);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.notifyScreenRotateToCallbacks);
    });
    it('callUpdateScbScreenPropertyByRotationOnce', 0, () => {
      // updateScbScreenPropertyByRotation
      let func2 = mocker.mockFunc(windowRotate, windowRotate.updateScbScreenPropertyByRotation);
      let count = 0;
      when(func2)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithNoAnimation updateScbScreenPropertyByRotation action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithNoAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.updateScbScreenPropertyByRotation);
    });
    it('callUpdateScreenRotationPropertyOnce', 0, () => {
      // updateScreenRotationProperty
      let func3 = mocker.mockFunc(windowRotate, windowRotate.updateScreenRotationProperty);
      let count = 0;
      when(func3)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithNoAnimation updateScreenRotationProperty action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithNoAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.updateScreenRotationProperty);
    });
    it('callNotifyScenePanelPropertyChangeOnce', 0, () => {
      // notifyScenePanelPropertyChange
      let func4 = mocker.mockFunc(windowRotate, windowRotate.notifyScenePanelPropertyChange);
      let count = 0;
      when(func4)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithNoAnimation notifyScenePanelPropertyChange action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithNoAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.notifyScenePanelPropertyChange);
    });
    it('callUpdateScreenPropertyToCallbacksOnce', 0, () => {
      // updateScreenPropertyToCallbacks
      let func5 = mocker.mockFunc(windowRotate, windowRotate.updateScreenPropertyToCallbacks);
      let count = 0;
      when(func5)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithNoAnimation updateScreenPropertyToCallbacks action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithNoAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.updateScreenPropertyToCallbacks);
    });
    it('callNotifySystemSceneToUpdateFoldModeOnce', 0, () => {
      // notifySystemSceneToUpdateFoldMode
      let func6 = mocker.mockFunc(windowRotate, windowRotate.notifySystemSceneToUpdateFoldMode);
      let count = 0;
      when(func6)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithNoAnimation notifySystemSceneToUpdateFoldMode action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithNoAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.notifySystemSceneToUpdateFoldMode);
    });
    it('callUpdateScbScreenPropertyByRotationOnce', 0, () => {
      // updateScbScreenPropertyByRotation
      let func1 = mocker.mockFunc(windowRotate, windowRotate.updateScbScreenPropertyByRotation);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation updateScbScreenPropertyByRotation action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.updateScbScreenPropertyByRotation);
    });
    it('callUpdateScreenRotationPropertyOnce', 0, () => {
      // updateScreenRotationProperty
      let func1 = mocker.mockFunc(windowRotate, windowRotate.updateScreenRotationProperty);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation updateScreenRotationProperty action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.updateScreenRotationProperty);
    });
    it('callNotifyScreenRotateToCallbacksOnce', 0, () => {
      // notifyScreenRotateToCallbacks
      let func1 = mocker.mockFunc(windowRotate, windowRotate.notifyScreenRotateToCallbacks);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation notifyScreenRotateToCallbacks action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.notifyScreenRotateToCallbacks);
    });
    it('callUpdateRotateAnimationConfigOnce', 0, () => {
      // updateRotateAnimationConfig
      let func1 = mocker.mockFunc(windowRotate, windowRotate.updateRotateAnimationConfig);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation updateRotateAnimationConfig action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.updateRotateAnimationConfig);
    });
    it('callPrepareSystemSceneRotationBeforeAnimationOnce', 0, () => {
      // prepareSystemSceneRotationBeforeAnimation
      let func1 = mocker.mockFunc(windowRotate, windowRotate.prepareSystemSceneRotationBeforeAnimation);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation prepareSystemSceneRotationBeforeAnimation action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.prepareSystemSceneRotationBeforeAnimation);
    });
    it('callNotifyKeyBoardBeforeRotationOnce', 0, () => {
      // notifyKeyBoardBeforeRotation
      let func1 = mocker.mockFunc(windowRotate, windowRotate.notifyKeyBoardBeforeRotation);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation notifyKeyBoardBeforeRotation action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.notifyKeyBoardBeforeRotation);
    });
    it('callNotifySystemSceneToUpdateSizeChangeReasonOnce', 0, () => {
      // notifySystemSceneToUpdateSizeChangeReason
      let func1 = mocker.mockFunc(windowRotate, windowRotate.notifySystemSceneToUpdateSizeChangeReason);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation notifySystemSceneToUpdateSizeChangeReason action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.notifySystemSceneToUpdateSizeChangeReason);
    });
    it('callSetActiveFloatUIFirstStateOnce', 0, () => {
      // setActiveFloatUIFirstState
      let func1 = mocker.mockFunc(windowRotate, windowRotate.setActiveFloatUIFirstState);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation setActiveFloatUIFirstState action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.setActiveFloatUIFirstState);
    });
    it('callNotifyScenePanelPropertyChangeOnce', 0, () => {
      // notifyScenePanelPropertyChange
      let func1 = mocker.mockFunc(windowRotate, windowRotate.notifyScenePanelPropertyChange);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation notifyScenePanelPropertyChange action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.notifyScenePanelPropertyChange);
    });
    it('callUpdateInvisibleSystemSceneFoldChangeOnce', 0, () => {
      // notifyScenePanelPropertyChange
      let func1 = mocker.mockFunc(windowRotate, windowRotate.updateInvisibleSystemSceneFoldChange);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation updateInvisibleSystemSceneFoldChange action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotateWithAnimation(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.updateInvisibleSystemSceneFoldChange);
    });
    it('callNotifyKeyBoardAfterRotationOnce', 0, () => {
      // notifyKeyBoardAfterRotation
      let func1 = mocker.mockFunc(windowRotate, windowRotate.notifyKeyBoardAfterRotation);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation notifyKeyBoardAfterRotation action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotationAnimationFinished(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.notifyKeyBoardAfterRotation);
    });
    it('callSetActiveFloatUIFirstStateOnce', 0, () => {
      // setActiveFloatUIFirstState
      let func1 = mocker.mockFunc(windowRotate, windowRotate.setActiveFloatUIFirstState);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation setActiveFloatUIFirstState action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotationAnimationFinished(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.setActiveFloatUIFirstState);
    });
    it('callNotifyScreenRotateToCallbacksOnce', 0, () => {
      // notifyScreenRotateToCallbacks
      let func1 = mocker.mockFunc(windowRotate, windowRotate.notifyScreenRotateToCallbacks);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation notifyScreenRotateToCallbacks action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotationAnimationFinished(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.notifyScreenRotateToCallbacks);
    });
    it('callUpdateScreenRotationPropertyOnce', 0, () => {
      // updateScreenRotationProperty
      let func1 = mocker.mockFunc(windowRotate, windowRotate.updateScreenRotationProperty);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation updateScreenRotationProperty action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotationAnimationFinished(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.updateScreenRotationProperty);
    });
    it('callNotifySystemSceneToUpdateSizeChangeReasonOnce', 0, () => {
      // notifySystemSceneToUpdateSizeChangeReason
      let func1 = mocker.mockFunc(windowRotate, windowRotate.notifySystemSceneToUpdateSizeChangeReason);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`testRotateWithAnimation notifySystemSceneToUpdateSizeChangeReason action ${count}`);
      });
      // run method rotateWithNoAnimation
      runRotationAnimationFinished(windowRotate);
      // verify
      expect(count).assertEqual(1);
      // ignore
      mocker.ignoreMock(windowRotate, windowRotate.notifySystemSceneToUpdateSizeChangeReason);
    });
  })
}

function buildScreenSession(): screenSessionManager.ScreenSession {
  let screenSession: screenSessionManager.ScreenSession = {
    screenId: -1,
    name: 'testScreen',
    on: (type: string, callback: Function): void => undefined,
    setScreenRotationLocked: (isLocked: boolean): void => undefined,
    loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => undefined,
    setTouchEnabled: (isTouchEnabled: boolean): void => undefined,
    getScreenUIContext: (): UIContext => {
      return sceneSessionManager.getRootSceneUIContext();
    }
  };
  return screenSession;
}

function runRotateWithNoAnimation(windowRotate: SCBWindowRotate) {
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  let screenSession: SCBScreenSession = new SCBScreenSession(buildScreenSession());
  log.showInfo('testRotateWithNoAnimation rotateWithNoAnimation begin');
  ReflectionUtils.useFunc(windowRotate, 'rotateWithNoAnimation',
    [screenProperty, SCBPropertyChangeReason.ROTATION, screenSession]);
  log.showInfo('testRotateWithNoAnimation rotateWithNoAnimation end');
}

function runRotateWithAnimation(windowRotate: SCBWindowRotate) {
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  let screenSession: SCBScreenSession = new SCBScreenSession(buildScreenSession());
  log.showInfo('testRotateWithAnimation rotateWithAnimation begin');
  ReflectionUtils.setProperty(windowRotate, "rotationAnimCnt", 2);
  ReflectionUtils.useFunc(windowRotate, 'rotateWithAnimation',
    [screenProperty, SCBPropertyChangeReason.ROTATION, screenSession]);
  log.showInfo('testRotateWithAnimation rotateWithAnimation end');
}

function runRotationAnimationFinished(windowRotate: SCBWindowRotate) {
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  let screenSession: SCBScreenSession = new SCBScreenSession(buildScreenSession());
  log.showInfo('testRotateWithAnimation rotateWithAnimation begin');
  ReflectionUtils.setProperty(windowRotate, "rotationAnimCnt", 1);
  ReflectionUtils.useFunc(windowRotate, 'rotationAnimationFinished',
    [screenProperty, SCBPropertyChangeReason.ROTATION, screenSession]);
  log.showInfo('testRotateWithAnimation rotateWithAnimation end');
}