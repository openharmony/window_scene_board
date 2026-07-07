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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import {
  AodRotationAdapterFactory
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/AodRotationAdapterFactory';
import display from '@ohos.display';
import { aodThemeManager, AodUtil, IAodDisplayInfo } from '@ohos/aod';
import { MockUtil } from '@ohos/aod/src/ohosTest/ets/test/MockUtil';
import { FoldPhoneTypeValue } from '@ohos/frameworkwrapper';
import { AodRotationTemplate } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/AodRotationTemplate';
import { RotationStrategy } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/RotationStrategy';
import { ThreeFoldAodUtil } from '@ohos/aod/src/main/ets/utils/ThreeFoldAodUtil';

export function AodRotationAdapterFactoryTest() {
  describe('AodRotationAdapterFactoryTest', () => {

    beforeAll((): void => {

    })

    beforeEach((): void => {

    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('test_crateDeviceConfigClt', 0, (): void => {
      const displayInfo = AodUtil.getAodDisplayInfo();

      const deviceConfig = AodRotationAdapterFactory.crateFoldRotationAdapter(displayInfo);

      expect(deviceConfig).not().assertUndefined();
    });

    it('test_getAodDisplayMode', 0, (): void => {
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      MockUtil.mockFuncForObj(AodUtil, 'isFullDisplayMode', (): boolean => {
        return true;
      });
      const displayMode = AodRotationAdapterFactory.getAodDisplayMode();
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getAodDisplayMode2', 0, (): void => {
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(AodUtil, 'isLemProductAndSubDisplay', (): boolean => {
        return true;
      });
      const displayMode = AodRotationAdapterFactory.getAodDisplayMode();
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getAodDisplayMode3', 0, (): void => {
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      MockUtil.mockFuncForObj(AodUtil, 'isFullDisplayMode', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(AodUtil, 'isLemProductAndSubDisplay', (): boolean => {
        return false;
      });
      const displayMode = AodRotationAdapterFactory.getAodDisplayMode();
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getAodDisplayInfo', 0, (): void => {
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      const displayInfo = AodUtil.getAodDisplayInfo();
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getAodDisplayInfo2', 0, (): void => {
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      let themeParam = aodThemeManager.getAodThemeParam();
      themeParam.isHalfFoldStatus = false;
      const displayInfo = AodUtil.getAodDisplayInfo(themeParam);
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getAodDisplayInfo3', 0, (): void => {
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      let themeParam = aodThemeManager.getAodThemeParam();
      themeParam.isHalfFoldStatus = true;
      const displayInfo = AodUtil.getAodDisplayInfo(themeParam);
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('AodRotationAdapterFactory_crateFoldRotationAdapter', 0, () => {
      const displayInfo = AodUtil.getAodDisplayInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodUtil, AodUtil.isRotationState);
      when(mockFunc)(displayInfo.deviceInfo).afterReturn(true);
      let result = AodRotationAdapterFactory.crateFoldRotationAdapter(displayInfo);
      expect(result).not().assertNull();
      mocker.clear(AodUtil);
      mocker.clearAll();
    });

    it('AodRotationAdapterFactory_createFoldRotationStrategy1', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.LARGE_FOLD,
          displayState: 1,
          foldState: 1
        }
      };
      let result: AodRotationTemplate =
        (AodRotationAdapterFactory as object)['createFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createFoldRotationStrategy2', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.SMALL_FOLD,
          displayState: 1,
          foldState: 1
        }
      };
      let result: AodRotationTemplate =
        (AodRotationAdapterFactory as object)['createFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createFoldRotationStrategy3', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.EXPANDING_NEX_FORMS,
          displayState: 1,
          foldState: 1
        }
      };
      let result: AodRotationTemplate =
        (AodRotationAdapterFactory as object)['createFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createFoldRotationStrategy4', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: AodRotationTemplate =
        (AodRotationAdapterFactory as object)['createFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createFoldRotationStrategy5', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.EXPANDING_THREE_FOLD_PRODUCT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: AodRotationTemplate =
        (AodRotationAdapterFactory as object)['createFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createLargeFoldRotationStrategy1', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.PORTRAIT,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createLargeFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createLargeFoldRotationStrategy2', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createLargeFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createLargeFoldRotationStrategy3', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.PORTRAIT_INVERTED,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createLargeFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createLargeFoldRotationStrategy4', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE_INVERTED,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createLargeFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createLargeFoldRotationStrategy5', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: 5,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createLargeFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createSquareFoldRotationStrategy1', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.PORTRAIT,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createSquareFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createSquareFoldRotationStrategy2', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createSquareFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createSquareFoldRotationStrategy3', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.PORTRAIT_INVERTED,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createSquareFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createSquareFoldRotationStrategy4', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE_INVERTED,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createSquareFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createSquareFoldRotationStrategy5', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: 5,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createSquareFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createThreeFoldRotationStrategy1', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.PORTRAIT,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      MockUtil.mockFuncForObj(ThreeFoldAodUtil, 'isFStatus', (): boolean => {
        return true;
      });
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createThreeFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
      MockUtil.clearAll();
    });

    it('AodRotationAdapterFactory_createThreeFoldRotationStrategy2', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.PORTRAIT,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      MockUtil.mockFuncForObj(ThreeFoldAodUtil, 'isFStatus', (): boolean => {
        return false;
      });
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createThreeFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
      MockUtil.clearAll();
    });

    it('AodRotationAdapterFactory_createThreeFoldRotationStrategy3', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      MockUtil.mockFuncForObj(ThreeFoldAodUtil, 'isFStatus', (): boolean => {
        return false;
      });
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createThreeFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
      MockUtil.clearAll();
    });

    it('AodRotationAdapterFactory_createThreeFoldRotationStrategy4', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.PORTRAIT_INVERTED,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      MockUtil.mockFuncForObj(ThreeFoldAodUtil, 'isFStatus', (): boolean => {
        return false;
      });
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createThreeFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
      MockUtil.clearAll();
    });

    it('AodRotationAdapterFactory_createThreeFoldRotationStrategy5', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE_INVERTED,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      MockUtil.mockFuncForObj(ThreeFoldAodUtil, 'isFStatus', (): boolean => {
        return false;
      });
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createThreeFoldRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
      MockUtil.clearAll();
    });

    it('AodRotationAdapterFactory_createPadRotationStrategy1', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createPadRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createPadRotationStrategy2', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.PORTRAIT_INVERTED,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createPadRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createPadRotationStrategy3', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.LANDSCAPE_INVERTED,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createPadRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createPadRotationStrategy4', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: display.Orientation.PORTRAIT,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createPadRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

    it('AodRotationAdapterFactory_createPadRotationStrategy5', 0, () => {
      let displayInfo: IAodDisplayInfo = {
        width: 10,
        height: 10,
        rotation: 5,
        orientation: display.getDefaultDisplaySync().orientation,
        deviceInfo: {
          deviceType: '1',
          phoneType: FoldPhoneTypeValue.STRAIGHT,
          displayState: 1,
          foldState: 1
        }
      };
      let result: RotationStrategy =
        (AodRotationAdapterFactory as object)['createPadRotationStrategy'](displayInfo);
      expect(result).not().assertNull();
    });

  });
}