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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { BaseNotification, immersiveKgMgr, ImmersiveType,
  ImmersiveTypeScene,
  LiveViewData,
  SysTypeCode} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { CardUpdateStratagemEnum, ImmersiveCardVm } from '../../../../../main/ets/viewmodel/ImmersiveCardVm';
import { immersiveVm } from '../../../../../main/ets/viewmodel/ImmersiveVm';
import { ImmersiveAnimManager } from '../../../../../main/ets/viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveDataGroupPacker } from '../../../../../main/ets/viewmodel/viewdata/ImmersiveDataGroupProcessor';
import { ImmersiveNtfData } from '../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';
import { ImmersiveCardData } from '../../../../../main/ets/viewmodel/viewdata/ImmersiveCardData';
import { ImmersiveConstants } from '../../../../../main/ets/common/ImmersiveConstants';
import { ImmersiveCardState } from '../../../../../main/ets/common/manager/ImmersiveStateManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ImmersiveCardList } from '../../../../../main/ets/viewmodel/viewdata/ImmersiveCardList';
import { CommonConstants } from '@ohos/screenlockcommon';
import { ImmInvertColorInfo } from '@ohos/screenlockcommon/Index';
import { InvertColor } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/immersivekg/bean/ImmInvertColorInfo';
import { ImmersiveCardStyle } from '../../../../../main/ets/model/data/ImmersiveCardStyle';
import { SlCardWidgetBindState } from '../../../../../main/ets/model/data/SlCardWidgetBindState';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveCardVmTest() {
  let mocker: MockKit = new MockKit();
  const isDevicePad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
  describe('ImmersiveCardVmTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    let ntfData = new ImmersiveNtfData();
    ntfData.id = 100;
    ntfData.groupKey = 'testGroupKey';
    ntfData.hashCode = 'testHashCode';
    let entry = new BaseNotification();
    let cardList = new ImmersiveCardList();

    it('test_initVm', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      cardVm.initVm();
      expect(cardVm).not().assertUndefined();
    });

    it('test_destroy', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      cardVm.destroy();
      expect(cardVm).not().assertUndefined();
    });

    it('test_setUpdateData_01', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      cardList.setShowData(ntfData);
      (cardVm as object)['showList'] = cardList;
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      cardVm.setUpdateData(ntfData, entry);
      expect(cardVm).not().assertUndefined();
    });

    it('test_setUpdateData_02', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      cardList.setShowData(ntfData);
      (cardVm as object)['showList'] = cardList;
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      cardVm.setUpdateData(ntfData, entry);
      expect(cardVm).not().assertUndefined();
    });

    it('test_setUpdateData_03', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      let ntfData2 = new ImmersiveNtfData();
      ntfData2.id = 101;
      ntfData2.groupKey = 'testGroupKey2';
      cardList.setShowData(ntfData2);
      (cardVm as object)['showList'] = cardList;
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      cardVm.setUpdateData(ntfData, entry);
      expect(cardVm).not().assertUndefined();
    });

    it('test_setUpdateData_04', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      let ntfData2 = new ImmersiveNtfData();
      ntfData2.id = 101;
      ntfData2.groupKey = 'testGroupKey2';
      cardList.setShowData(ntfData2);
      (cardVm as object)['showList'] = cardList;
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      cardVm.setUpdateData(ntfData, entry);
      expect(cardVm).not().assertUndefined();
    });

    it('test_isNeedToAnim_01', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      let res: boolean = (cardVm as object)['isNeedToAnim'](ntfData);
      expect(res).assertTrue();
    });

    it('test_isNeedToAnim_02', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      cardData.immersiveWant = { bundleName: 'com.ohos.sceneboard' };
      let ntfData2 = new ImmersiveNtfData();
      ntfData2.cardData = cardData;
      cardList.setShowData(ntfData2);
      (cardVm as object)['showList'] = cardList;
      let res: boolean = (cardVm as object)['isNeedToAnim'](ntfData);
      expect(res).assertFalse();
    });

    it('test_isNeedToAnim_03', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      let liveViewData: LiveViewData = new LiveViewData();
      liveViewData.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      cardData.liveView = liveViewData;
      ntfData.cardData = cardData;
      let res: boolean = (cardVm as object)['isNeedToAnim'](ntfData);
      expect(res).assertFalse();
    });

    it('test_startCardUpdateAnim', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      let res: Promise<void> = (cardVm as object)['startCardUpdateAnim'](entry);
      expect(res).not().assertNull();
    });

    it('test_updateInvertColor_01', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      let curInvertColor: ImmInvertColorInfo = new ImmInvertColorInfo();
      curInvertColor.setImmBackBtnColor(InvertColor.COLOR_BLACK);
      (cardVm as object)['isSmallFoldOuterScreen'] = true;
      (cardVm as object)['updateInvertColor'](curInvertColor);
      expect(cardVm).not().assertUndefined();
    });

    it('test_updateInvertColor_02', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      let curInvertColor: ImmInvertColorInfo = new ImmInvertColorInfo();
      curInvertColor.setImmBackBtnColor(InvertColor.COLOR_WHITE);
      (cardVm as object)['isSmallFoldOuterScreen'] = true;
      (cardVm as object)['updateInvertColor'](curInvertColor);
      expect(cardVm).not().assertUndefined();
    });

    it('test_updateInvertColor_03', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      let curInvertColor: ImmInvertColorInfo = new ImmInvertColorInfo();
      (cardVm as object)['isSmallFoldOuterScreen'] = false;
      (cardVm as object)['updateInvertColor'](curInvertColor);
      expect(cardVm).not().assertUndefined();
    });

    it('testCheckAndUpdateUiData', Level.LEVEL0, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      cardVm.checkAndUpdateUiData();
      expect(cardVm).not().assertUndefined();
    });

    it('testCheckAndUpdateUiData_02', Level.LEVEL0, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let state = new ImmersiveCardState();
      cardVm.checkAndUpdateUiData(state, true);
      expect(cardVm).not().assertUndefined();
    });

    it('testCheckAndUpdateUiData_03', Level.LEVEL0, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let state = new ImmersiveCardState();
      cardVm.checkAndUpdateUiData(state, false);
      expect(cardVm).not().assertUndefined();
    });

    it('test_checkShouldShowImmersiveDefault', Level.LEVEL0, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.checkShouldShowImmersiveDefault();
      expect(res).assertFalse();
    });

    it('testGetPanelState', Level.LEVEL0, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getPanelState();
      expect(res).not().assertNull();
    });

    it('testGetShowList', Level.LEVEL0, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getShowList();
      expect(res).not().assertNull();
    });

    it('test_setIsOtherTheme', Level.LEVEL0, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      cardVm.setIsOtherTheme(true);
      cardVm.setIsOtherTheme(false);
      expect(cardVm).not().assertUndefined();
    });

    it('testGetCardStyle', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardStyle();
      expect(res).not().assertNull();
    });

    it('testGetLiveStyle', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getLiveStyle();
      expect(res).not().assertNull();
    });

    it('test_getSmallFoldOuterStyle', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getSmallFoldOuterStyle();
      expect(res).not().assertNull();
    });

    it('testHasOwnBackgroundImage', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.hasOwnBackgroundImage();
      expect(cardVm).not().assertUndefined();
    });

    it('testClickToApp', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fd';
      immersiveNtfData.groupKey = 'grouptest';
      immersiveNtfData.creatorBundleName = 'mytest.com';
      immersiveNtfData.appName = 'myapp';
      immersiveNtfData.id = 10000;
      cardVm.clickToApp(immersiveNtfData);
      expect(cardVm).not().assertUndefined();
    });

    it('testUpdateCardHeight', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      cardVm.updateCardHeight(false, 100);
      cardVm.updateCardHeight(true, 100);
      cardVm.updateCardHeight(false, 1);
      cardVm.updateCardHeight(true, 1);
      expect(cardVm).not().assertUndefined();
    });

    it('testUpdateCardHeight_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let cardStyle = new ImmersiveCardStyle();
      cardStyle.widescreenHeight = 10;
      (cardVm as object)['cardStyle'] = cardStyle;
      cardVm.updateCardHeight(true, 5);
      expect(cardVm).not().assertUndefined();
    });

    it('testUpdateCardHeight_03', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let cardStyle = new ImmersiveCardStyle();
      cardStyle.widescreenHeight = 10;
      (cardVm as object)['cardStyle'] = cardStyle;
      cardVm.updateCardHeight(true, 15);
      expect(cardVm).not().assertUndefined();
    });

    it('testUpdateCardHeight_04', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let cardStyle = new ImmersiveCardStyle();
      cardStyle.widescreenHeight = 10;
      when(isDevicePad)().afterReturn(true);
      (cardVm as object)['cardStyle'] = cardStyle;
      cardVm.updateCardHeight(false, 5);
      expect(cardVm).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('testUpdateCardHeight_05', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let cardStyle = new ImmersiveCardStyle();
      cardStyle.widescreenHeight = 10;
      when(isDevicePad)().afterReturn(true);
      (cardVm as object)['cardStyle'] = cardStyle;
      cardVm.updateCardHeight(false, 15);
      expect(cardVm).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('testUpdateCardHeight_06', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let cardStyle = new ImmersiveCardStyle();
      cardStyle.widescreenHeight = 10;
      when(isDevicePad)().afterReturn(false);
      (cardVm as object)['cardStyle'] = cardStyle;
      cardVm.updateCardHeight(false, 5);
      expect(cardVm).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('testUpdateCardHeight_07', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let cardStyle = new ImmersiveCardStyle();
      cardStyle.widescreenHeight = 10;
      when(isDevicePad)().afterReturn(false);
      (cardVm as object)['cardStyle'] = cardStyle;
      cardVm.updateCardHeight(false, 15);
      expect(cardVm).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('testGetNoPermissionTip', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      cardData.locationErrorCode = ImmersiveConstants.LOCATION_ERROR_CODE.NO_PERMISSION;
      cardVm.getNoPermissionTip(cardData);
      cardData.locationErrorCode = ImmersiveConstants.LOCATION_ERROR_CODE.LOCATION_SWITCH_OFF;
      cardVm.getNoPermissionTip(cardData);
      expect(cardVm).not().assertUndefined();
    });

    it('testGetTipsLineHeight', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let font: Resource = $r('app.float.immersive_location_font_line_height');
      let res = cardVm.getTipsLineHeight(font);
      expect(cardVm).not().assertUndefined();
    });

    it('testGetTipsLineHeight_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      when(isDevicePad)().afterReturn(true);
      let font: Resource = $r('app.float.immersive_location_font_line_height');
      let res = cardVm.getTipsLineHeight(font);
      expect(cardVm).not().assertUndefined();
    });

    it('testGetTipsLineHeight_03', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['isSmallFoldOuterScreen'] = true;
      let font: Resource = $r('app.float.immersive_location_font_line_height');
      let res = cardVm.getTipsLineHeight(font);
      expect(cardVm).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('testGetTipsFontScale', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getTipsFontScale();
      expect(cardVm).not().assertUndefined();
    });

    it('testGetTipsFontScale_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      when(isDevicePad)().afterReturn(true);
      let res = cardVm.getTipsFontScale();
      expect(cardVm).not().assertUndefined();
    });

    it('testGetTipsFontScale_03', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['isSmallFoldOuterScreen'] = true;
      let res = cardVm.getTipsFontScale();
      expect(cardVm).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('testCheckIsHideTipImage', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.checkIsHideTipImage();
      expect(cardVm).not().assertUndefined();
    });

    it('testCheckIsHideTipImage_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      when(isDevicePad)().afterReturn(true);
      let res = cardVm.checkIsHideTipImage();
      expect(cardVm).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('test_getUpdateStratagem', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['isSmallFoldOuterScreen'] = true;
      let res: CardUpdateStratagemEnum = (cardVm as object)['getUpdateStratagem']();
      expect(res).assertEqual(CardUpdateStratagemEnum.SMALL_SCREEN);
    });

    it('test_getUpdateStratagem_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['isSmallFoldOuterScreen'] = false;
      let res: CardUpdateStratagemEnum = (cardVm as object)['getUpdateStratagem']();
      expect(res).assertEqual(CardUpdateStratagemEnum.DEFAULT);
    });

    it('testOnclickGoSettingBtn', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.creatorBundleName = 'mytest.com';
      cardData.locationErrorCode = ImmersiveConstants.LOCATION_ERROR_CODE.NO_PERMISSION;
      cardVm.onclickGoSettingBtn(cardData, immersiveNtfData);
      cardData.locationErrorCode = ImmersiveConstants.LOCATION_ERROR_CODE.LOCATION_SWITCH_OFF;
      cardVm.onclickGoSettingBtn(cardData, immersiveNtfData);
      expect(cardVm).not().assertUndefined();
    });

    it('testLocationAuthorization', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      cardVm.locationAuthorization(true);
      cardVm.locationAuthorization(true, 'mytestboundName');
      cardVm.locationAuthorization(false);
      cardVm.locationAuthorization(false, 'mytestboundName');
      expect(cardVm).not().assertUndefined();
    });

    it('testReceiveExtensionData', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      let receiveData: Record<string, Object> = {};
      let res = cardVm.receiveExtensionData(cardData, receiveData);
      expect(cardVm).not().assertUndefined();
    });

    it('testHasLocationErrorCode', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res1 = cardVm.hasLocationErrorCode(ImmersiveConstants.LOCATION_ERROR_CODE.NO_PERMISSION);
      let res2 = cardVm.hasLocationErrorCode(ImmersiveConstants.LOCATION_ERROR_CODE.LOCATION_SWITCH_OFF);
      let res3 = cardVm.hasLocationErrorCode(0);
      expect(res1).assertTrue();
      expect(res2).assertTrue();
      expect(res3).assertFalse();
    });

    it('test_changeCardState', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      cardVm.changeCardState(true);
      cardVm.changeCardState(false);
      expect(cardVm).not().assertUndefined();
    });

    it('test_changeCardState_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let bindCardStateCtrl = new SlCardWidgetBindState();
      bindCardStateCtrl.setIsCardFold(true);
      (cardVm as object)['bindCardStateCtrl'] = bindCardStateCtrl;
      cardVm.changeCardState(true);
      expect(cardVm).not().assertUndefined();
    });

    it('test_changeCardState_03', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let bindCardStateCtrl = new SlCardWidgetBindState();
      bindCardStateCtrl.setIsCardFold(true);
      (cardVm as object)['bindCardStateCtrl'] = bindCardStateCtrl;
      cardVm.changeCardState(false);
      expect(cardVm).not().assertUndefined();
    });

    it('test_changeCardState_04', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let bindCardStateCtrl = new SlCardWidgetBindState();
      bindCardStateCtrl.setIsCardFold(false);
      (cardVm as object)['bindCardStateCtrl'] = bindCardStateCtrl;
      cardVm.changeCardState(true);
      expect(cardVm).not().assertUndefined();
    });

    it('test_changeCardState_05', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let bindCardStateCtrl = new SlCardWidgetBindState();
      bindCardStateCtrl.setIsCardFold(false);
      (cardVm as object)['bindCardStateCtrl'] = bindCardStateCtrl;
      cardVm.changeCardState(false);
      expect(cardVm).not().assertUndefined();
    });

    it('test_getCardTipImg_01', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardTipImg(true, true);
      expect(res).not().assertNull();
    });

    it('test_getCardTipImg_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardTipImg(true, false);
      expect(res).not().assertNull();
    });

    it('test_getCardTipImg_03', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardTipImg(false, true);
      expect(res).not().assertNull();
    });

    it('test_getCardTipImg_04', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardTipImg(false, false);
      expect(res).not().assertNull();
    });

    it('test_getCardAlign_01', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardAlign(true, true);
      expect(res).not().assertNull();
    });

    it('test_getCardAlign_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardAlign(true, false);
      expect(res).not().assertNull();
    });

    it('test_getCardAlign_03', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardAlign(false, true);
      expect(res).not().assertNull();
    });

    it('test_getCardAlign_04', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardAlign(false, false);
      expect(res).not().assertNull();
    });

    it('test_getCardMargin_01', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardMargin(true, true);
      expect(res).not().assertNull();
    });

    it('test_getCardMargin_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardMargin(true, false);
      expect(res).not().assertNull();
    });

    it('test_getCardMargin_03', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardMargin(false, true);
      expect(res).not().assertNull();
    });

    it('test_getCardMargin_04', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res = cardVm.getCardMargin(false, false);
      expect(res).not().assertNull();
    });

    it('test_clearCardFoldFlag_02', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let bindCardStateCtrl = new SlCardWidgetBindState();
      bindCardStateCtrl.setIsCardFold(false);
      (cardVm as object)['bindCardStateCtrl'] = bindCardStateCtrl;
      (cardVm as object)['clearCardFoldFlag'](50);
      expect(cardVm).not().assertUndefined();
    });

    it('test_doClearCardFoldFlag', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['doClearCardFoldFlag']();
      expect(cardVm).not().assertUndefined();
    });

    it('testInitCardStyle', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['initCardStyle']();
      expect(cardVm).not().assertUndefined();
    });

    it('testUpdateCardStyle', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['updateCardStyle']();
      expect(cardVm).not().assertUndefined();
    });

    it('testUpdateTipStyle', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['updateTipStyle']();
      expect(cardVm).not().assertUndefined();
    });

    it('testCheckUiDataForStateChanged', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let state: ImmersiveCardState = new ImmersiveCardState();
      (cardVm as object)['checkUiDataForStateChanged'](state);
      expect(cardVm).not().assertUndefined();
    });

    it('testSetDelayTimeout', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['setDelayTimeout']();
      (cardVm as object)['clearDelayTimeout']();
      expect(cardVm).not().assertUndefined();
    });

    it('test_clearDelayTimeout', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['delayCheckDismiss'] = 1;
      (cardVm as object)['clearDelayTimeout']();
      expect(cardVm).not().assertUndefined();
    });

    it('testCheckUiDataForDataChanged', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(false);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveKgMgr.exitImmersiveState(true);
      (cardVm as object)['checkUiDataForDataChanged']();
      expect(cardVm).not().assertUndefined();
    });

    it('testIsNeedAnim', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['isNeedAnim']();
      expect(cardVm).not().assertUndefined();
    });

    it('testFindGroupData', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fd';
      immersiveNtfData.groupKey = 'grouptest';
      immersiveNtfData.creatorBundleName = 'mytest.com';
      immersiveNtfData.appName = 'myapp';
      immersiveNtfData.id = 10000;
      let ntfDatas: ImmersiveNtfData[] = [];
      ntfDatas.push(immersiveNtfData);
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']();
      (cardVm as object)['findGroupData']('grouptest');
      expect(cardVm).not().assertUndefined();
    });

    it('testFindGroupData_02', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fds';
      immersiveNtfData.groupKey = '';
      let ntfDatas: ImmersiveNtfData[] = [];
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']();
      (cardVm as object)['findGroupData']('');
      expect(cardVm).not().assertUndefined();
    });

    it('testFindGroupData_03', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fds';
      immersiveNtfData.groupKey = '';
      let ntfDatas: ImmersiveNtfData[] = [];
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']();
      (cardVm as object)['findGroupData']('grouptest');
      expect(cardVm).not().assertUndefined();
    });

    it('testCardStageChange', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['cardStageChange']();
      expect(cardVm).not().assertUndefined();
    });

    it('testUpdatePanelPaddingTop', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['updatePanelPaddingTop']();
      expect(cardVm).not().assertUndefined();
    });

    it('testResetLocationErrorCode', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let showData = undefined;
      (cardVm as object)['resetLocationErrorCode'](showData);
      let showData2 =  new ImmersiveNtfData();
      showData2.cardData = new ImmersiveCardData();
      (cardVm as object)['resetLocationErrorCode'](showData2);
      let showData3 =  new ImmersiveNtfData();
      showData3.cardData = new ImmersiveCardData();
      (cardVm as object)['resetLocationErrorCode'](showData3);
      expect(cardVm).not().assertUndefined();
    });

    it('testGetLocationSwitchTip', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      cardData.immersiveWant = { bundleName: 'com.ohos.sceneboard' };
      (cardVm as object)['getLocationSwitchTip'](cardData);
      cardData.immersiveWant = { bundleName: 'test' };
      (cardVm as object)['getLocationSwitchTip'](cardData);
      expect(cardVm).not().assertUndefined();
    });

    it('testGetCurrentUserId', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let res: number = (cardVm as object)['getCurrentUserId']();
      expect(res).assertEqual(CommonConstants.DEFAULT_USER_ID);
    });

    it('testStartDoWantAgent', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fd';
      immersiveNtfData.groupKey = 'grouptest';
      immersiveNtfData.creatorBundleName = 'mytest.com';
      immersiveNtfData.appName = 'myapp';
      immersiveNtfData.id = 10000;
      (cardVm as object)['startDoWantAgent'](immersiveNtfData);
      expect(cardVm).not().assertUndefined();
    });

    it('testOnRootStateAnimatingChange', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['onRootStateAnimatingChange']();
      expect(cardVm).not().assertUndefined();
    });

    it('test_handleUiDataForDestroy', Level.LEVEL1, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['handleUiDataForDestroy']();
      expect(cardVm).not().assertUndefined();
    });

    it('ImmersiveCardVm_hasPermission_return_true', Level.LEVEL0, (done: Function) => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let result: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
      expect(cardVm).not().assertUndefined();
      done();
    })

    it('ImmersiveCardVm_hasPermission_return_false', Level.LEVEL0, (done: Function) => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let result1: boolean = cardVm.hasPermission('com.test.test','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
      expect(result1).assertFalse();
      let result2: boolean = cardVm.hasPermission('com.ohos.sceneboard','ohos.permission.TEST');
      expect(result2).assertFalse();
      done();
    })

    it('getNoPermissionTip_test01', Level.LEVEL0, () => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let immersiveCardData:ImmersiveCardData = new ImmersiveCardData();
      immersiveCardData.locationErrorCode = ImmersiveConstants.LOCATION_ERROR_CODE.NO_PERMISSION;
      cardVm.getNoPermissionTip(immersiveCardData);
      expect(cardVm).not().assertUndefined();
      immersiveCardData.locationErrorCode = ImmersiveConstants.LOCATION_ERROR_CODE.NO_PERMISSION;
      cardVm.getNoPermissionTip(immersiveCardData);
      expect(cardVm).not().assertUndefined();
    });

    it('getTipsLineHeight_test01', Level.LEVEL0, () => {
      let font: Resource = $r('app.float.immersive_location_font_line_height');
      let cardVm = immersiveVm.getImmersiveCardVm();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper,DeviceHelper.isPad);
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper,DeviceHelper.isFullDisplayMode);
      when(mockFunc)().afterReturn(true);
      cardVm.getTipsLineHeight(font);
      expect(cardVm).not().assertUndefined();

      when(mockFunc)().afterReturn(false);
      when(mockFunc1)().afterReturn(true);
      cardVm.getTipsLineHeight(font);
      expect(cardVm).not().assertUndefined();

      when(mockFunc)().afterReturn(false);
      when(mockFunc1)().afterReturn(false);
      cardVm.getTipsLineHeight(font);
      expect(cardVm).not().assertUndefined();
      mocker.clear(DeviceHelper);
    });

    it('getTipsFontScale_test01', Level.LEVEL0, () => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper,DeviceHelper.isPad);
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper,DeviceHelper.isFullDisplayMode);
      when(mockFunc)().afterReturn(true);
      cardVm.getTipsFontScale();
      expect(cardVm).not().assertUndefined();

      when(mockFunc)().afterReturn(false);
      when(mockFunc1)().afterReturn(true);
      cardVm.getTipsFontScale();
      expect(cardVm).not().assertUndefined();

      when(mockFunc)().afterReturn(false);
      when(mockFunc1)().afterReturn(false);
      cardVm.getTipsFontScale();
      expect(cardVm).not().assertUndefined();
      mocker.clear(DeviceHelper);
    });

    it('checkIsHideTipImage_test01', Level.LEVEL0, () => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper,DeviceHelper.isPad);
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper,DeviceHelper.isFullDisplayMode);
      (cardVm as object)['isSmallFoldOuterScreen'] = true;
      cardVm.checkIsHideTipImage();
      expect(cardVm).not().assertUndefined();

      (cardVm as object)['isSmallFoldOuterScreen'] = false;
      when(mockFunc)().afterReturn(true);
      cardVm.checkIsHideTipImage();
      expect(cardVm).not().assertUndefined();

      (cardVm as object)['isSmallFoldOuterScreen'] = false;
      when(mockFunc)().afterReturn(false);
      when(mockFunc1)().afterReturn(true);
      cardVm.checkIsHideTipImage();
      expect(cardVm).not().assertUndefined();

      (cardVm as object)['isSmallFoldOuterScreen'] = false;
      when(mockFunc)().afterReturn(false);
      when(mockFunc1)().afterReturn(false);
      cardVm.checkIsHideTipImage();
      expect(cardVm).not().assertUndefined();
      mocker.clear(DeviceHelper);
    });

    it('getTipBtnWidth_test01', Level.LEVEL0, () => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['isSmallFoldOuterScreen'] = true;
      let res: Length | undefined = (cardVm as object)['getTipBtnWidth']();
      expect(res).not().assertUndefined();
    });

    it('getTipBtnWidth_test02', Level.LEVEL0, () => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['isSmallFoldOuterScreen'] = false;
      let res: Length | undefined = (cardVm as object)['getTipBtnWidth']();
      expect(res).assertUndefined();
    });

    it('getTipBgColor_test01', Level.LEVEL0, () => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['isSmallFoldOuterScreen'] = true;
      let res: Resource | undefined = (cardVm as object)['getTipBgColor']();
      expect(res).not().assertUndefined();
    });

    it('getTipBgColor_test02', Level.LEVEL0, () => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['isSmallFoldOuterScreen'] = false;
      let res: Resource | undefined = (cardVm as object)['getTipBgColor']();
      expect(res).assertUndefined();
    });

    it('receiveExtensionData_test01', Level.LEVEL0, () => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      let receiveData: Record<string, Object> = {};
      receiveData.errCode === undefined;
      cardVm.receiveExtensionData(cardData,receiveData);
      expect(cardVm).not().assertUndefined();
    });

    it('testSetDelayTimeout_test01', Level.LEVEL0, (): void => {
      let cardVm = immersiveVm.getImmersiveCardVm();
      (cardVm as object)['delayCheckDismiss'] = 1;;
      (cardVm as object)['setDelayTimeout']();
      expect(cardVm).not().assertUndefined();
      (cardVm as object)['delayCheckDismiss'] = null;;
      (cardVm as object)['setDelayTimeout']();
      expect(cardVm).not().assertUndefined();
    });

    it('testFindGroupData_test01', Level.LEVEL1, (): void => {
      let animManager = new ImmersiveAnimManager();
      let packer = new ImmersiveDataGroupPacker();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'fds';
      immersiveNtfData.groupKey = '';
      let ntfDatas: ImmersiveNtfData[] = [immersiveNtfData];
      (packer as object)['groupList'] = ntfDatas;
      let cardVm = new ImmersiveCardVm(animManager, packer);
      (cardVm as object)['findGroupData']('grouptest');
      expect(cardVm).not().assertUndefined();
    });
  });
}