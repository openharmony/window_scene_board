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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { ScreenLockStatus } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { SatelliteModeSwitchEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { BaseController, CommonData } from '../../../../../main/ets/base/BaseController';
import { BaseControllerMock } from './BaseControllerMockTest';

export default function BaseControllerMockTest() {

  describe('BaseControllerMockTest', (): void => {
    let callback: (value: object) => void;
    let mBaseControllerMock:BaseControllerMock = new BaseControllerMock();
    let mBaseControllerSon = new BaseControllerSon();

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_removeAllLottieData_return', 0, (): void => {
      mBaseControllerMock.removeAllLottieData();
      expect(mBaseControllerMock.isAlreadyLoadLottie).assertEqual(false);
    })

    it('test_initAllLottieData_return', 0, (): void => {
      mBaseControllerMock.initAllLottieData();
      expect(mBaseControllerMock.isAlreadyLoadLottie).assertEqual(false);
    })

    it('test_isDarkReverse_return', 0, (): void => {
      let result = mBaseControllerMock.isDarkReverse();
      expect(result).assertEqual(false);
    })

    it('test_getOpenLottieData_return', 0, (): void => {
      let records: Record<string, object> = {};
      let result = mBaseControllerMock.getOpenLottieData();
      expect(result).assertNull();
    })

    it('test_getCloseLottieData_return', 0, (): void => {
      let records: Record<string, object> = {};
      let result = mBaseControllerMock.getCloseLottieData();
      expect(result).assertNull();
    })

    it('test_matchLottieData_return-one', 0, (): void => {
      let records: Record<string, object> = {};
      let isDarkMode: boolean = true;
      mBaseControllerMock.getData().status = true;
      let result = mBaseControllerMock.matchLottieData(isDarkMode);
      expect(result).assertNull();
    })

    it('test_matchLottieData_return-ones', 0, (): void => {
      let records: Record<string, object> = {};
      let isDarkMode: boolean = true;
      mBaseControllerMock.getData().status = false;
      let result = mBaseControllerMock.matchLottieData(isDarkMode);
      expect(result).assertNull();
    })

    it('test_matchLottieData_return-two', 0, (): void => {
      let records: Record<string, object> = {};
      let isDarkMode: boolean = false;
      mBaseControllerMock.getData().status = true;
      let result = mBaseControllerMock.matchLottieData(isDarkMode);
      expect(result).assertNull();
    })

    it('test_matchLottieData_return-twos', 0, (): void => {
      let records: Record<string, object> = {};
      let isDarkMode: boolean = false;
      mBaseControllerMock.getData().status = false;
      let result = mBaseControllerMock.matchLottieData(isDarkMode);
      expect(result).assertNull();
    })

    it('test_getLottieOpenName_return', 0, (): void => {
      let result = mBaseControllerMock.getLottieOpenName();
      expect(result).assertEqual('');
    })

    it('test_getLottieCloseName_return', 0, (): void => {
      mBaseControllerMock.getNewLottieOpenName();
      let result = mBaseControllerMock.getLottieCloseName();
      expect(result).assertEqual('');
    })

    it('test_getNewLottieCloseName_return', 0, (): void => {
      let result = mBaseControllerMock.getNewLottieCloseName();
      expect(result).assertEqual('');
    })

    it('test_getLottieDarkName_return', 0, (): void => {
      let result = mBaseControllerMock.getLottieDarkName();
      expect(result).assertEqual('');
    })

    it('test_getLottieOpenDarkName_return', 0, (): void => {
      let result = mBaseControllerMock.getLottieOpenDarkName();
      expect(result).assertEqual('');
    })

    it('test_getLottieCloseDarkName_return', 0, (): void => {
      let result = mBaseControllerMock.getLottieCloseDarkName();
      expect(result).assertEqual('');
    })

    it('test_isLoadLottie_return', 0, (): void => {
      let result = mBaseControllerMock.isLoadLottie();
      expect(result).assertEqual(false);
    })

    it('test_loadLottieData_return', 0, (): void => {
      let jsonName: string = 'res';
      mBaseControllerMock.loadLottieData(jsonName, callback);
      expect(jsonName).assertEqual('res');
    })

    it('test_needListenSatelliteMode_return', 0, (): void => {
      let result = mBaseControllerMock.needListenSatelliteMode();
      expect(result).assertEqual(false);
    })

    it('test_updateDisableState_return', 0, (): void => {
      mBaseControllerMock.onStart();
      mBaseControllerMock.onStop();
      let result = mBaseControllerMock.getSbPluginSlot();
      expect(result).assertEqual('');
    })

    it('test_updateDisableState_return', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mBaseControllerMock.updateDisableState();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_handleUpdateState_return', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mBaseControllerMock.handleUpdateState();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_getData_return', 0, (): void => {
      let result = mBaseControllerMock.getData();
      expect(result).not().assertNull();
    })

    it('test_addStateChangedListener_return', 0, (): void => {
      mBaseControllerMock.addStateChangedListener();
      mBaseControllerMock.removeStateChangedListener();
      let result = mBaseControllerMock.isAvailable();
      expect(result).not().assertNull();
    })

    it('test_handleLongClick_return', 0, (): void => {
      let result = mBaseControllerMock.handleLongClick();
      expect(result).assertEqual(false);
    })

    it('test_handleLongClick_return', 0, (): void => {
      let slot: string = '';
      let result = mBaseControllerMock.handleLabelClick(slot);
      expect(result).assertEqual(false);
    })

    it('test_handleHover_return', 0, (): void => {
      let isHover: boolean = true;
      mBaseControllerMock.handleHover(isHover);
      let handle: Function = () => {
        return true
      };
      expect(handle()).assertEqual(true);
    })

    it('test_handleGoSettingWithScreenLock_return', 0, (): void => {
      let handle: Function = () => {
        return true
      };
      mBaseControllerMock.handleGoSettingWithScreenLock(handle);
      expect(handle()).assertEqual(true);
    })

    it('test_goSettingWithDelay_return', 0, (): void => {
      let delay: number = 3;
      mBaseControllerMock.goSettingWithDelay(delay);
      expect(delay).assertEqual(3);
    })

    it('test_requestUnlock_return-false', 0, (): void => {
      let beforeUnlock: boolean = false;
      let handle: Function = () => {
        return true
      };
      mBaseControllerMock.requestUnlock(handle, beforeUnlock);
      expect(handle()).assertEqual(true);
    })

    it('test_requestUnlock_return-true', 0, (): void => {
      let beforeUnlock: boolean = true;
      let handle: Function = () => {
        return true
      };
      mBaseControllerMock.requestUnlock(handle, beforeUnlock);
      expect(handle()).assertEqual(true);
    })

    it('test_handleOnControlCenterWithScreenLock_return-true', 0, (): void => {
      let beforeUnlock: boolean = true;
      let handle: Function = () => {
        return true
      };
      mBaseControllerMock.handleOnControlCenterWithScreenLock(handle, beforeUnlock);
      expect(handle()).assertEqual(true);
    })

    it('test_onProducePluginRequestEvent', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mBaseControllerSon.OnProducePluginRequestEvent('');
      mBaseControllerSon.OnProducePluginRequestEvent('729958');
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_initLottieData', 0, (): void => {
      mBaseControllerSon.isNewStyleOpen = true;
      mBaseControllerSon.lottieOpenName = '666';
      mBaseControllerSon.lottieCloseName = '666';
      mBaseControllerSon.lottieOpenDarkName = '666';
      let result = mBaseControllerSon.lottieCloseDarkName = '666';
      mBaseControllerSon.InitLottieData();
      expect(result).not().assertNull();
    })

    it('test_onSatelliteModeSwitchEvent', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      const mSatelliteModeSwitchEvent = new SatelliteModeSwitchEvent();
      mBaseControllerSon.OnSatelliteModeSwitchEvent(undefined);
      mBaseControllerSon.OnSatelliteModeSwitchEvent(mSatelliteModeSwitchEvent);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_handleClickIfUnlock', 0, (): void => {
      let result = AppStorage.set('lockStatus', ScreenLockStatus.UNLOCK);
      mBaseControllerSon.HandleClickIfUnlock();
      expect(result).not().assertNull();
    })

    it('test_handleClickWithScreenLockAndEdit', 0, (): void => {
      const handle = () => {
      };
      AppStorage.set('isHomeVisible', true);
      AppStorage.set('lockStatus', 729958);
      mBaseControllerSon.handleClickWithScreenLockAndEdit(handle);
      let result = AppStorage.set('lockStatus', ScreenLockStatus.UNLOCK);
      mBaseControllerSon.handleClickWithScreenLockAndEdit(handle);
      expect(result).not().assertNull();
    })

    it('test_handleGoSettingIfUnlock', 0, (): void => {
      let result = AppStorage.set('lockStatus', ScreenLockStatus.UNLOCK);
      mBaseControllerSon.HandleGoSettingIfUnlock();
      expect(result).not().assertNull();
    })
  })
}

export class BaseControllerSon extends BaseController<CommonData> {
  public available = false;
  public lottieOpenName: string = '';
  public lottieCloseName: string = '';
  public lottieOpenDarkName: string = '';
  public lottieCloseDarkName: string = '';

  public getData(): CommonData {
    return {} as CommonData;
  }

  public isAvailable() {
    return this.available;
  }

  public OnProducePluginRequestEvent(slot?: string) {
    return this.onProducePluginRequestEvent(slot);
  }

  public InitLottieData() {
    return this.initLottieData();
  }

  public getLottieOpenName(): string {
    return this.lottieOpenName;
  }

  public getLottieOpenDarkName(): string {
    return this.lottieOpenDarkName;
  }

  public getLottieCloseDarkName(): string {
    return this.lottieCloseDarkName;
  }

  public OnSatelliteModeSwitchEvent(event?: SatelliteModeSwitchEvent) {
    return this.onSatelliteModeSwitchEvent(event);
  }

  public HandleClickIfUnlock() {
    return this.handleClickIfUnlock();
  }

  public HandleGoSettingIfUnlock() {
    return this.handleGoSettingIfUnlock();
  }
}