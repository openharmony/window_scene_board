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
import { describe, expect, it } from '@ohos/hypium';
import {
  ControlCenterSysEventUtil
} from '../../../../../../../main/ets/com/ohos/common/usecase/ControlCenterSysEventUtil';

export function ControlCenterSysEventUtilTest() {
  describe('ControlCenterSysEventUtilTest', () => {
    it('ControlCenterSysEventUtil_001', 0, () => {
      expect(ControlCenterSysEventUtil.getSum("", '1') === -1).assertEqual(true);
      expect(ControlCenterSysEventUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(ControlCenterSysEventUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(ControlCenterSysEventUtil.getSum('1', '') === -1).assertEqual(true);
      expect(ControlCenterSysEventUtil.getSum('1', null) === -1).assertEqual(true);
      expect(ControlCenterSysEventUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(ControlCenterSysEventUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('ControlCenterSysEventUtil_002', 0, () => {
      expect(ControlCenterSysEventUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('ControlCenterSysEventUtil_003', 0, () => {
      expect(ControlCenterSysEventUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(ControlCenterSysEventUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('ControlCenterSysEventUtil_004', 0, () => {
      expect(ControlCenterSysEventUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(ControlCenterSysEventUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('ControlCenterSysEventUtil_005', 0, () => {
      expect(ControlCenterSysEventUtil.isNumber("")).assertFalse();
      expect(ControlCenterSysEventUtil.isNumber(null)).assertFalse();
      expect(ControlCenterSysEventUtil.isNumber(undefined)).assertFalse();
      expect(ControlCenterSysEventUtil.isNumber("abc")).assertFalse();
      expect(ControlCenterSysEventUtil.isNumber("123")).assertTrue();
    });

    it('ControlCenterSysEventUtil_006', 0, () => {
      expect(ControlCenterSysEventUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(ControlCenterSysEventUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(ControlCenterSysEventUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(ControlCenterSysEventUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(ControlCenterSysEventUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(ControlCenterSysEventUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('ControlCenterSysEventUtil_007', 0, () => {
      expect(ControlCenterSysEventUtil.getDefaultId(null) === null).assertTrue();
      expect(ControlCenterSysEventUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(ControlCenterSysEventUtil.getDefaultId('') === '').assertTrue();
      expect(ControlCenterSysEventUtil.getDefaultId('default') !== '').assertTrue();
      expect(ControlCenterSysEventUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(ControlCenterSysEventUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('ControlCenterSysEventUtil_008', 0, () => {
      expect(ControlCenterSysEventUtil.getIndexByString("", []) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('ControlCenterSysEventUtil_009', 0, () => {
      expect(ControlCenterSysEventUtil.drawFontWidth() === -1).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWidth(100) === 1).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWidth(200) === 2).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWidth(300) === 3).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWidth(400) === 4).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWidth(500) === 6).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWidth(600) === 7).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWidth(700) === 8).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWidth(800) === 9).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWidth(900) === 1).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(ControlCenterSysEventUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('ControlCenterSysEventUtil_010', 0, () => {
      expect(ControlCenterSysEventUtil.drawTextAlign() === -1).assertTrue();
      expect(ControlCenterSysEventUtil.drawTextAlign(100) === 0).assertTrue();
      expect(ControlCenterSysEventUtil.drawTextAlign(200) === 1).assertTrue();
      expect(ControlCenterSysEventUtil.drawTextAlign(300) === 2).assertTrue();
      expect(ControlCenterSysEventUtil.drawTextAlign(400) === 3).assertTrue();
      expect(ControlCenterSysEventUtil.drawTextAlign(500) === 4).assertTrue();
      expect(ControlCenterSysEventUtil.drawTextAlign(600) === 5).assertTrue();
      expect(ControlCenterSysEventUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('ControlCenterSysEventUtil_011', 0, () => {
      expect(ControlCenterSysEventUtil.getStringIndex('', '') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('ControlCenterSysEventUtil_012', 0, () => {
      expect(ControlCenterSysEventUtil.checkArr([]) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(null) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(undefined) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(['a', '']) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(['a', null]) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(ControlCenterSysEventUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(ControlCenterSysEventUtil.getUUID().length > 0).assertTrue();
    })

    it('ControlCenterSysEventUtil_013', 0, () => {
      expect(ControlCenterSysEventUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(ControlCenterSysEventUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('ControlCenterSysEventUtil_014', 0, () => {
      expect(ControlCenterSysEventUtil.getBinaryData(null, '') === '').assertTrue();
      expect(ControlCenterSysEventUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(ControlCenterSysEventUtil.getBinaryData(2, null) === '').assertTrue();
      expect(ControlCenterSysEventUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(ControlCenterSysEventUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(ControlCenterSysEventUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(ControlCenterSysEventUtil.getBinaryData(0, '') === '').assertTrue();
      expect(ControlCenterSysEventUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('ControlCenterSysEventUtil_015', 0, () => {
      expect(ControlCenterSysEventUtil.getArraySum(null, []) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getArraySum([], null) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(ControlCenterSysEventUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('ControlCenterSysEventUtil_016', 0, () => {
      expect(ControlCenterSysEventUtil.isEmpty(null)).assertTrue();
      expect(ControlCenterSysEventUtil.isEmpty(undefined)).assertTrue();
      expect(ControlCenterSysEventUtil.isEmpty('')).assertTrue();
      expect(ControlCenterSysEventUtil.isEmpty(0)).assertTrue();
      expect(ControlCenterSysEventUtil.isEmpty([])).assertTrue();
      expect(ControlCenterSysEventUtil.isEmpty(1, null)).assertTrue();
      expect(ControlCenterSysEventUtil.isEmpty(1, undefined)).assertTrue();
      expect(ControlCenterSysEventUtil.isEmpty(1, true)).assertTrue();
      expect(ControlCenterSysEventUtil.isEmpty(1, false)).assertFalse();
    })

    it('ControlCenterSysEventUtil_017', 0, () => {
      expect(ControlCenterSysEventUtil.equals(null, 'a')).assertFalse();
      expect(ControlCenterSysEventUtil.equals(undefined, 'a')).assertFalse();
      expect(ControlCenterSysEventUtil.equals('a', null)).assertFalse();
      expect(ControlCenterSysEventUtil.equals('a', undefined)).assertFalse();
      expect(ControlCenterSysEventUtil.equals('a', 1)).assertFalse();
      expect(ControlCenterSysEventUtil.equals(1, 'a')).assertFalse();
      expect(ControlCenterSysEventUtil.equals(1, [])).assertFalse();
      expect(ControlCenterSysEventUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(ControlCenterSysEventUtil.equals([], m)).assertFalse();
      expect(ControlCenterSysEventUtil.equals(m, [])).assertFalse();
      expect(ControlCenterSysEventUtil.equals([1,2], [])).assertFalse();
      expect(ControlCenterSysEventUtil.equals([], [1, 2])).assertFalse();
      expect(ControlCenterSysEventUtil.equals([1], [1, 2])).assertFalse();
      expect(ControlCenterSysEventUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(ControlCenterSysEventUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(ControlCenterSysEventUtil.equals(2, 2)).assertTrue();
    })

    it('CommonToggleControllerTest001', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest002', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest003', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let HandleUpdateState = commonToggleController.getViewData();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest004', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let HandleClick = commonToggleController.handleOneClick();

    })

    it('CommonToggleControllerTest005', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
    })

    it('CommonToggleControllerTest006', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleControllerTest007', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest008', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleOneClick();

    })

    it('CommonToggleControllerTest009', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleOneClick();

    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let HandleClick = commonToggleController.handleOneClick();

    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleOneClick();

    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleOneClick();
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleOneClick();
    })

    it('CommonToggleControllerTest019', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest020', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest021', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleOneClick();
    })

    it('CommonToggleControllerTest022', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let data = commonToggleController.getViewData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.isAvailable();
      expect(HandleUpdateState !== null).assertEqual(true);
      let HandleClick = commonToggleController.isAvailable();

      let HandleLongClick = commonToggleController.isAvailable();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest023', 0, (): void => {
      let commonToggleController = new ApplicationToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleController_handleClickTest01', 0, (): void => {
      let sCommonToggleController = new ApplicationToggleController(PluginSlot.SLOT_CONTROL_SCREENSHOT);
      sCommonToggleController.handleOneClick();
    })

    it('CommonToggleController_handleClickTest02', 0, (): void => {
      let sCommonToggleController = new ApplicationToggleController(PluginSlot.SLOT_CONTROL_SCREEN_RECORDER);
      let get = mocker.mockFunc(AppStorage, AppStorage.get);
      when(get)('lockStatus').afterReturn(1);
      sCommonToggleController.handleOneClick();
      expect(get('lockStatus') == 1).assertTrue();
      mocker.clear(AppStorage);
    })

    it('ControlBrightnessManagerTest_001', 0, (): void => {
      mBrightnessManager.init(5);
      mBrightnessManager.getMin();
      mBrightnessManager.getMax();
      mBrightnessManager.getDefault();
      mBrightnessManager.setBrightnessUiValue(undefined);
      mBrightnessManager.setBrightnessUiValue(10);
      (mBrightnessManager as object)['resetTaskFlags']();
      mBrightnessManager.setControlCenterVisible(false);
      mBrightnessManager.setControlCenterVisible(true);
      mBrightnessManager.registerBrightness();
      mBrightnessManager.unRegisterBrightness();
      expect(mBrightnessManager.isControlCenterVisible).assertTrue();
    })

    it('ControlBrightnessManagerTest_executeTaskDelay', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mBrightnessManager, (mBrightnessManager as object)['needExecuteTask']);
      when(mockFunc)().afterReturn(false);
      (mBrightnessManager as object)['executeTaskDelay']();
      when(mockFunc)().afterReturn(true);
      (mBrightnessManager as object)['executeTaskDelay']();
      (mBrightnessManager as object)['needExecuteTaskOnceMore'] = true;
      (mBrightnessManager as object)['resetTaskFlags']();
      expect((mBrightnessManager as object)['needExecuteTaskOnceMore']).assertFalse();
      mocker.clear(mBrightnessManager);
    })

    it('ControlBrightnessManagerTest_needExecuteTask_1', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(MemoryManager.getInstance(), MemoryManager.getInstance().checkIsStaticMemoryScene);
      when(mockFunc)().afterReturn(true);
      expect((mBrightnessManager as object)['needExecuteTask']()).assertFalse();
      mocker.clear(MemoryManager.getInstance());
    })

    it('ControlBrightnessManagerTest_needExecuteTask_2', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(MemoryManager.getInstance(), MemoryManager.getInstance().checkIsStaticMemoryScene);
      when(mockFunc)().afterReturn(false);
      (mBrightnessManager as object)['taskTimerId'] = undefined;
      expect((mBrightnessManager as object)['needExecuteTask']()).assertTrue();
      mocker.clear(MemoryManager.getInstance());
    })

    it('ControlBrightnessManagerTest_needExecuteTask_3', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(MemoryManager.getInstance(), MemoryManager.getInstance().checkIsStaticMemoryScene);
      when(mockFunc)().afterReturn(false);
      (mBrightnessManager as object)['taskTimerId'] = 1;
      mBrightnessManager.isControlCenterVisible = false;
      expect((mBrightnessManager as object)['needExecuteTask']()).assertTrue();
      mocker.clear(MemoryManager.getInstance());
    })

    it('ControlBrightnessManagerTest_needExecuteTask_4', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(MemoryManager.getInstance(), MemoryManager.getInstance().checkIsStaticMemoryScene);
      when(mockFunc)().afterReturn(false);
      (mBrightnessManager as object)['taskTimerId'] = 1;
      mBrightnessManager.isControlCenterVisible = true;
      expect((mBrightnessManager as object)['needExecuteTask']()).assertFalse();
      mBrightnessManager.unRegisterBrightness();
      mocker.clear(MemoryManager.getInstance());
    })

    it('ControlCenterBaseControllerTest0010', 0, (): void => {
      let getLottieCloseName: string = ControlCenterBaseController.getLottieCloseName();
      expect(getLottieCloseName !== null).assertEqual(true);
    })

    it('ControlCenterBaseControllerTest0011', 0, (): void => {
      let getNewLottieCloseName: string = ControlCenterBaseController.getNewLottieCloseName();
      expect(getNewLottieCloseName !== null).assertEqual(true);
    })
  });
}