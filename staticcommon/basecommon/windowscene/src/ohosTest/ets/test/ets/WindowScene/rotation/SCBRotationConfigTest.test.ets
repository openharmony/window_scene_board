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
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  when
} from '@ohos/hypium';
import screenSessionManager from '@ohos.screenSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ReflectionUtils } from '../utils/ReflectionUtils';
import {
  OrientationMapping,
  RotationConfigType,
  SCBRotationConfig
} from '../../../../../../main/ets/rotation/SCBRotationConfig';
import { FoldPhoneTypeValue, ScreenState, ScreenStateMonitor } from '@ohos/frameworkwrapper';
import { SCBScreenSession } from '../../../../../../main/ets/screen/session/SCBScreenSession';
import { RotationConstants } from '@ohos/commonconstants';

const TAG = 'SCBRotationConfigTest';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export function SCBRotationConfigTest() {

  let rotationConfig: SCBRotationConfig;

  describe('Product_SCBRotationConfigTest', () => {
    beforeAll(() => {
      rotationConfig = SCBRotationConfig.getInstance();
      ReflectionUtils.setProperty(rotationConfig, 'rotatableArray', ['1']);
      ReflectionUtils.setProperty(rotationConfig, 'orientationMappingArray', ['0,90,180,270']);
      ReflectionUtils.setProperty(rotationConfig, 'compatibleLandscapeArray', ['1']);
      ReflectionUtils.setProperty(rotationConfig, 'fixedRotationArray', ['-1']);
      ReflectionUtils.setProperty(rotationConfig, 'rotationOptimizationSwitch', true);
      ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState = ScreenState.F;
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('isFoldAndExpandScreenType', Level.LEVEL0, () => {
      let resStraight: boolean =
        ReflectionUtils.useFunc(rotationConfig, 'isFoldAndExpandScreenType', FoldPhoneTypeValue.STRAIGHT);
      expect(resStraight).assertTrue();

      let resLargeFold: boolean =
        ReflectionUtils.useFunc(rotationConfig, 'isFoldAndExpandScreenType', FoldPhoneTypeValue.LARGE_FOLD);
      expect(resLargeFold).assertTrue();

      let resExternalFold: boolean =
        ReflectionUtils.useFunc(rotationConfig, 'isFoldAndExpandScreenType', FoldPhoneTypeValue.EXTERNAL_FOLD);
      expect(resExternalFold).assertTrue();

      let resOther: boolean =
        ReflectionUtils.useFunc(rotationConfig, 'isFoldAndExpandScreenType', FoldPhoneTypeValue.EXPANDING_NEX_FORMS);
      expect(resOther).assertFalse();
    })

    it('isFoldExpandTentHoverScreenType', Level.LEVEL0, () => {
      let resExpandingNexFroms: boolean =
        ReflectionUtils.useFunc(rotationConfig, 'isFoldExpandTentHoverScreenType',
          FoldPhoneTypeValue.EXPANDING_NEX_FORMS);
      expect(resExpandingNexFroms).assertTrue();

      let resOther: boolean =
        ReflectionUtils.useFunc(rotationConfig, 'isFoldExpandTentHoverScreenType', FoldPhoneTypeValue.STRAIGHT);
      expect(resOther).assertFalse();
    })

    it('isFMGScreenType', Level.LEVEL0, () => {
      let resExpandingThreeFoldProduct: boolean =
        ReflectionUtils.useFunc(rotationConfig, 'isFMGScreenType',
          FoldPhoneTypeValue.EXPANDING_THREE_FOLD_PRODUCT);
      expect(resExpandingThreeFoldProduct).assertTrue();

      let resOther: boolean =
        ReflectionUtils.useFunc(rotationConfig, 'isFMGScreenType', FoldPhoneTypeValue.STRAIGHT);
      expect(resOther).assertFalse();
    })

    it('getStringValueByFoldScreenType', Level.LEVEL0, () => {
      let scbScreenSession = buildScreenSession();
      let res: string =
        ReflectionUtils.useFunc(rotationConfig, 'getStringValueByFoldScreenType', ['0'], scbScreenSession,
          RotationConfigType.INVALID_CONFIG);
      expect(res).assertEqual('0');
    })

    it('getConfigValueIndex', Level.LEVEL0, () => {
      let scbScreenSession = buildScreenSession();
      let res: number = ReflectionUtils.useFunc(rotationConfig, 'getConfigValueIndex', scbScreenSession);
      expect(res).assertEqual(0);
    })

    it('getDefaultRotationConfig', Level.LEVEL0, () => {
      let res: string =
        ReflectionUtils.useFunc(rotationConfig, 'getDefaultRotationConfig', RotationConfigType.INVALID_CONFIG);
      expect(res).assertEqual('0');
    })

    it('parseOrientationMappingToObject', Level.LEVEL0, () => {
      let res: OrientationMapping =
        ReflectionUtils.useFunc(rotationConfig, 'parseOrientationMappingToObject', '0,90,180,270');
      expect(res._portrait).assertEqual(RotationConstants.ROTATION_0);
      expect(res._landscape).assertEqual(RotationConstants.ROTATION_90);
      expect(res._reversePortrait).assertEqual(RotationConstants.ROTATION_180);
      expect(res._reverseLandscape).assertEqual(RotationConstants.ROTATION_270);
    })

    it('isValidOrientation', Level.LEVEL0, () => {
      let resValid: boolean = ReflectionUtils.useFunc(rotationConfig, 'isValidOrientation', 0);
      expect(resValid).assertTrue();

      let resInvalid: boolean = ReflectionUtils.useFunc(rotationConfig, 'isValidOrientation', -1);
      expect(resInvalid).assertFalse();
    })

    it('initDeviceRotationConfig', Level.LEVEL0, () => {
      // mock function
      let mocker = new MockKit();
      // initDeviceRotationConfig
      let func1 = mocker.mockFunc(rotationConfig, rotationConfig.initDeviceRotationConfig);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`initDeviceRotationConfig action ${count}`);
      });
      // run method initDeviceRotationConfig
      rotationConfig.initDeviceRotationConfig();
      // verify
      expect(count).assertEqual(1);

      let scbScreenSession = buildScreenSession();

      let resRotatable: boolean = rotationConfig.isDeviceRotatable(scbScreenSession);
      expect(resRotatable).assertTrue();

      let resOrientationMappingObject: OrientationMapping =
        rotationConfig.getDeviceOrientationMappingObject(scbScreenSession);
      let orientationMappingObjectCompareRes: boolean =
        isOrientationMappingEqual(resOrientationMappingObject, new OrientationMapping());
      expect(orientationMappingObjectCompareRes).assertTrue();

      let resCompatibleLandscape: boolean = rotationConfig.isDeviceCompatibleLandscape(scbScreenSession);
      expect(resCompatibleLandscape).assertTrue();

      let resFixedRotation: number = rotationConfig.getDeviceFixedRotation(scbScreenSession);
      expect(resFixedRotation).assertEqual(-1);

      let resRotationOptimizationSwitchOn: boolean = rotationConfig.isDeviceRotationOptimizationSwitchOn();
      expect(resRotationOptimizationSwitchOn).assertTrue();

      // ignore
      mocker.ignoreMock(rotationConfig, rotationConfig.initDeviceRotationConfig);
    });

    it('isDeviceRotatable', Level.LEVEL0, () => {
      let scbScreenSession = buildScreenSession();
      let res: boolean = rotationConfig.isDeviceRotatable(scbScreenSession);
      expect(res).assertTrue();
    });

    it('getDeviceOrientationMappingObject', Level.LEVEL0, () => {
      let scbScreenSession = buildScreenSession();
      let res: OrientationMapping = rotationConfig.getDeviceOrientationMappingObject(scbScreenSession);
      let resCompare: boolean = isOrientationMappingEqual(res, new OrientationMapping());
      expect(resCompare).assertTrue();
    });

    it('getVerticalRotation', Level.LEVEL0, () => {
      let scbScreenSession = buildScreenSession();
      let res: number = rotationConfig.getVerticalRotation(scbScreenSession);
      expect(res).assertEqual(0);
    });

    it('getHorizontalRotation', Level.LEVEL0, () => {
      let scbScreenSession = buildScreenSession();
      let res: number = rotationConfig.getHorizontalRotation(scbScreenSession);
      expect(res).assertEqual(270);
    });

    it('getReverseVerticalRotation', Level.LEVEL0, () => {
      let scbScreenSession = buildScreenSession();
      let res: number = rotationConfig.getReverseVerticalRotation(scbScreenSession);
      expect(res).assertEqual(180);
    });

    it('getReverseHorizontalRotation', Level.LEVEL0, () => {
      let scbScreenSession = buildScreenSession();
      let res: number = rotationConfig.getReverseHorizontalRotation(scbScreenSession);
      expect(res).assertEqual(90);
    });

    it('isDeviceCompatibleLandscape', Level.LEVEL0, () => {
      let scbScreenSession = buildScreenSession();
      let res: boolean = rotationConfig.isDeviceCompatibleLandscape(scbScreenSession);
      expect(res).assertTrue();
    });

    it('getDeviceFixedRotation', Level.LEVEL0, () => {
      let scbScreenSession = buildScreenSession();
      let res: number = rotationConfig.getDeviceFixedRotation(scbScreenSession);
      expect(res).assertEqual(-1);
    });

    it('isDeviceRotationOptimizationSwitchOn', Level.LEVEL0, () => {
      let res: boolean = rotationConfig.isDeviceRotationOptimizationSwitchOn();
      expect(res).assertTrue();
    });
  })
}

function buildScreenSession(): SCBScreenSession {
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
  let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);
  return scbScreenSession;
}

function isOrientationMappingEqual(obj1: OrientationMapping, obj2: OrientationMapping): boolean {
  // 为空不比较
  if (!obj1 || !obj2) {
    return false;
  }
  // 逐个比较每个字段
  return obj1._portrait === obj2._portrait && obj1._landscape === obj2._landscape &&
    obj1._reversePortrait === obj2._reversePortrait && obj1._reverseLandscape === obj2._reverseLandscape;
}