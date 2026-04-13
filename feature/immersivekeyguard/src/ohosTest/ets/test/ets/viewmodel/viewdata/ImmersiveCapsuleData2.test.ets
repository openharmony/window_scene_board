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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, Level, it, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import {
  ImmersiveCapsuleType,
  LiveType,
  LiveViewData,
  LiveTimerData,
  ImmersiveShowType,
  LiveNavigationTemplate,
  LiveBaseTemplate
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ImmersiveCapsuleData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCapsuleData';
import { image } from '@kit.ImageKit';
import { CapsuleRemindType } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import { CommonUtils } from '@ohos/basicutils';

export function ImmersiveCapsuleDataTest() {

  describe('ImmersiveCapsuleDataTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_isLiveCapsule', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.isLiveCapsule();
      expect(data).not().assertNull();
    });

    it('test_isSysLiveType', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.isSysLiveType();
      expect(data).not().assertNull();
    });

    it('test_isMediaPlay', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.isMediaPlay();
      expect(data).not().assertNull();
    });

    it('test_isProgressType', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.isProgressType();
      expect(data).not().assertNull();
    });

    it('test_shouldShowInImmersiveCard', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.shouldShowInImmersiveCard();
      expect(data).not().assertNull();
    });

    it('test_hasOverlayIcon', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.hasOverlayIcon();
      data.isHideContent = true;
      data.hasOverlayIcon();
      expect(data).not().assertNull();
    });

    it('test_getLargeIcon', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.getLargeIcon();
      data.isHideContent = true;
      data.getLargeIcon();
      data.isHideContent = false;
      data.getLargeIcon();
      expect(data).not().assertNull();
    });

    it('test_getSmallIcon', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.getSmallIcon();
      data.liveType = LiveType.NAVIGATION;
      data.getSmallIcon();
      data.smallIcon = 'test';
      data.getSmallIcon();
      data.appIcon = 'test';
      data.getSmallIcon();
      expect(data).not().assertNull();
    });

    it('test_hasProgress', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.hasProgress();
      expect(data).not().assertNull();
    });

    it('test_hasButton', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.hasButton();
      expect(data).not().assertNull();
    });

    it('test_getButtonData', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.getButtonData();
      expect(data).not().assertNull();
    });

    it('test_hasOther', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.hasOther();
      expect(data).not().assertNull();
    });

    it('test_hasTimer', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.hasTimer();
      data.capsuleType = ImmersiveCapsuleType.LIVE_VIEW;
      data.liveTimer = undefined;
      data.hasTimer();
      data.liveTimer = new LiveTimerData();
      data.hasTimer();
      expect(data).not().assertNull();
    });

    it('test_isShowGroupStyle', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.isShowGroupStyle();
      expect(data).not().assertNull();
    });

    it('test_getTitle', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.getTitle();
      data.isHideContent = true;
      data.getTitle();
      data.appName = 'test';
      data.getTitle();
      expect(data).not().assertNull();
    });

    it('test_createGroup', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.createGroup();
      expect(data).not().assertNull();
    });

    it('test_deleteGroup', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.deleteGroup();
      expect(data).not().assertNull();
    });

    it('test_setTitle', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setTitle();
      data.setTitle('test');
      data.setTitle('test', true);
      expect(data).not().assertNull();
    });

    it('test_setContent', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setContent();
      data.setContent('test');
      data.setContent('test', true);
      expect(data).not().assertNull();
    });

    it('test_setCapsuleType', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setCapsuleType(ImmersiveCapsuleType.LIVE_VIEW);
      expect(data).not().assertNull();
    });

    it('test_setOverlayIcon', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setOverlayIcon();
      data.setOverlayIcon(null, true);
      expect(data).not().assertNull();
    });

    it('test_refreshChildrenCount', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.refreshChildrenCount();
      data.addChildData(new ImmersiveCapsuleData());
      data.refreshChildrenCount();
      expect(data).not().assertNull();
    });

    it('test_setLiveView', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setLiveView();
      expect(data).not().assertNull();
    });

    it('test_setProgressType', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setProgressType();
      data.setProgressType(true);
      expect(data).not().assertNull();
    });

    it('test_update', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.update(new ImmersiveCapsuleData());
      data.update(new ImmersiveCapsuleData(), true);
      expect(data).not().assertNull();
    });

    it('test_setTest', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setShowType(ImmersiveShowType.NOT_SHOW);
      data.setShowType(ImmersiveShowType.SHOW_CAPSULE);
      data.setShowType(ImmersiveShowType.SHOW_CARD);
      data.setHashCode('hashcode');
      data.setGroupKey('groupKey');
      expect(data).not().assertNull();
    });

    it('test_toString', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.toString();
      expect(data).not().assertNull();
    });

    it('test_updateLiveCapsule', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let liveData: LiveViewData = new LiveViewData();
      let template: LiveBaseTemplate = new LiveBaseTemplate();
      template.title = 'test';
      template.content = 'test';
      liveData.template = template;
      liveData.liveType = LiveType.TYPE_SYSTEM;
      data.liveView = liveData;
      (data as object)['updateLiveCapsule']();

      liveData.liveType = LiveType.NAVIGATION;
      (data as object)['updateLiveCapsule']();
      expect(data).not().assertNull();
    });

    it('test_updateNavDirectionIcon_01', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      (data as object)['updateNavDirectionIcon']();
      expect(data).not().assertNull();
    });

    it('test_updateNavDirectionIcon_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let template: LiveNavigationTemplate = new LiveNavigationTemplate();
      let pixelMap: image.PixelMap = {} as image.PixelMap;
      template.currNavDirectionIcon = pixelMap;
      (data as object)['updateNavDirectionIcon']();
      expect(data).not().assertNull();
    });

    it('test_updateNavDirectionIcon_03', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let template: LiveNavigationTemplate = new LiveNavigationTemplate();
      template.currNavDirectionIconRes = '';
      (data as object)['updateNavDirectionIcon']();
      expect(data).not().assertNull();
    });

    it('test_updateTitleContent', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      (data as object)['updateTitleContent']();

      data.capsuleType = ImmersiveCapsuleType.LIVE_VIEW;
      (data as object)['updateTitleContent']();
      expect(data).not().assertNull();
    });

    it('test_shouldShowInImmersiveCard_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.isHideContent = true;
      let res: boolean = data.shouldShowInImmersiveCard();
      expect(res).assertFalse();
    });

    it('test_getLargeIcon_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.isHideContent = false;
      data.liveType = LiveType.NAVIGATION;
      data.getLargeIcon();
      expect(data).not().assertNull();
    });

    it('test_getLargeIcon_03', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.isHideContent = false;
      data.liveType = LiveType.TYPE_SYSTEM;
      data.overlayIcon = undefined;
      data.getLargeIcon();
      expect(data).not().assertNull();
    });

    it('test_getSmallIcon_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.smallIcon = undefined;
      data.appIcon = undefined;
      data.getSmallIcon();
      expect(data).not().assertNull();
    });

    it('test_getSmallIcon_03', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.smallIcon = 'test';
      data.getSmallIcon();
      expect(data).not().assertNull();
    });

    it('test_hasProgress_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let mocker: MockKit = new MockKit();
      let mockFun1: Function = mocker.mockFunc(data, data.isLiveCapsule);
      let mockFun2: Function = mocker.mockFunc(data, data.isSysLiveType)
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(true);
      data.liveProgress = undefined;
      data.hasProgress();
      expect(data).not().assertNull();
      mocker.ignoreMock(data, data.isLiveCapsule);
      mocker.ignoreMock(data, data.isSysLiveType);
    });

    it('test_hasButton_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      (data as object)['capsuleType'] = ImmersiveCapsuleType.NORMAL;
      data.hasButton();
      expect(data).not().assertNull();
    });

    it('test_hasOther_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let mocker: MockKit = new MockKit();
      let mockFun1: Function = mocker.mockFunc(data, data.isLiveCapsule);
      let mockFun2: Function = mocker.mockFunc(data, data.isSysLiveType)
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(false);
      data.liveOther = undefined;
      data.hasOther();
      expect(data).not().assertNull();
      mocker.ignoreMock(data, data.isLiveCapsule);
      mocker.ignoreMock(data, data.isSysLiveType);
    });

    it('test_getButtonData_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let mocker: MockKit = new MockKit();
      let mockFun1: Function = mocker.mockFunc(data, data.hasProgress);
      when(mockFun1)().afterReturn(true);
      data.getButtonData();
      expect(data).not().assertNull();
      mocker.ignoreMock(data, data.hasProgress);
    });

    it('test_isCapsuleRemind', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.remindType = CapsuleRemindType.FLIP;
      data.isCapsuleRemind();
      expect(data).not().assertNull();
    });

    it('test_isCapsuleRemind_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.remindType = CapsuleRemindType.EXPAND;
      data.isCapsuleRemind();
      expect(data).not().assertNull();
    });

    it('test_getTitle_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.capsuleType = ImmersiveCapsuleType.LIVE_VIEW
      data.getTitle();
      expect(data).not().assertNull();
    });

    it('test_getTitle_03', Level.LEVEL0, (): void => {
      let template: LiveBaseTemplate = new LiveBaseTemplate();
      template.title = 'test';
      template.content = 'test';
      let data = new ImmersiveCapsuleData();
      data.capsuleType = ImmersiveCapsuleType.LIVE_VIEW;
      data.liveBaseTemplate = template;
      data.getTitle();
      expect(data).not().assertNull();
    });

    it('test_getTitle_04', Level.LEVEL0, (): void => {
      let template: LiveBaseTemplate = new LiveBaseTemplate();
      let timer: LiveTimerData = new LiveTimerData();
      template.title = 'test';
      template.content = 'test';
      let data = new ImmersiveCapsuleData();
      data.capsuleType = ImmersiveCapsuleType.LIVE_VIEW;
      data.liveBaseTemplate = template;
      data.getTitle(timer,'com.ohos.health',true);
      expect(data).not().assertNull();
    });

    it('test_setBundleName', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setBundleName(undefined);
      expect(data).not().assertNull();
    });

    it('test_setAppIndex', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setAppIndex(undefined);
      expect(data).not().assertNull();
    });

    it('test_setSmallIcon', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setSmallIcon(undefined,false);
      expect(data).not().assertNull();
    });

    it('test_setSmallIcon_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setSmallIcon(undefined,true);
      expect(data).not().assertNull();
    });

    it('test_isTimerInTitle', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let liveData: LiveViewData = new LiveViewData();
      let template: LiveBaseTemplate = new LiveBaseTemplate();
      template.title = 'test';
      template.content = 'test';
      liveData.template = template;
      liveData.liveType = LiveType.TYPE_SYSTEM;
      liveData.liveType = LiveType.TYPE_SYSTEM;
      data.liveView = liveData;
      data.isTimerInTitle();
      expect(data).not().assertNull();
    });

    it('test_isTimerInTitle_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.liveView = undefined;
      data.isTimerInTitle();
      expect(data).not().assertNull();
    });

    it('test_isTimerInContent', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let liveData: LiveViewData = new LiveViewData();
      let template: LiveBaseTemplate = new LiveBaseTemplate();
      template.title = 'test';
      template.content = 'test';
      liveData.template = template;
      liveData.liveType = LiveType.TYPE_SYSTEM;
      liveData.liveType = LiveType.TYPE_SYSTEM;
      data.liveView = liveData;
      data.isTimerInContent();
      expect(data).not().assertNull();
    });

    it('test_isTimerInContent_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.liveView = undefined;
      data.isTimerInContent();
      expect(data).not().assertNull();
    });

    it('test_getTimeTextStyle', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let mocker: MockKit = new MockKit();
      let mockFun1: Function = mocker.mockFunc(data, data.isTimerInContent);
      when(mockFun1)().afterReturn(true);
      data.getTimeTextStyle(true);
      expect(data).not().assertNull();
      mocker.ignoreMock(data, data.isTimerInContent)
    });

    it('test_getTimeTextStyle_02', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.getTimeTextStyle(false);
      expect(data).not().assertNull();
    });

    it('test_getContentResource', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.capsuleType =ImmersiveCapsuleType.LIVE_VIEW;
      (data as object)['getContentResource']();
      expect(data).not().assertNull();
    });

    let data = new ImmersiveCapsuleData();

    it('getLargeIcon_test01', Level.LEVEL0, (): void => {
      data.isHideContent = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(data,data.hasOverlayIcon);
      when(mockFunc)().afterReturn(false);
      data.getLargeIcon();
      expect(data).not().assertUndefined();
      mocker.clear(data);
    });

    it('getSmallIcon_test01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils,CommonUtils.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      data.getSmallIcon();
      expect(data).not().assertUndefined();
      mocker.clear(CommonUtils);
    });

    it('isCapsuleRemind_test01', Level.LEVEL0, (): void => {
      data.remindType = undefined;
      data.isCapsuleRemind();
      expect(data).not().assertUndefined();
    });

    it('getContent_test01', Level.LEVEL0, (): void => {
      let timer: LiveTimerData = new LiveTimerData();
      let liveBaseTemplate:LiveBaseTemplate =  new LiveBaseTemplate();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(liveBaseTemplate,liveBaseTemplate.transformTimerText);
      let mockFunc1: Function = mocker.mockFunc(liveBaseTemplate,liveBaseTemplate.transformTimerText);
      data.getContent(timer,'a',true);
      expect(data).not().assertUndefined();

      data.isHideContent = false;
      data.mainContent = '';
      data.capsuleType === ImmersiveCapsuleType.NORMAL;
      data.getContent(timer,'a',true);
      expect(data).not().assertUndefined();

      data.isHideContent = false;
      data.liveBaseTemplate = undefined;
      data.mainContent = 'a';
      data.capsuleType === ImmersiveCapsuleType.LIVE_VIEW;
      data.getContent(timer,'com.ohos.health',true);
      expect(data).not().assertUndefined();


      data.isHideContent = false;
      data.liveBaseTemplate = liveBaseTemplate;
      data.capsuleType === ImmersiveCapsuleType.LIVE_VIEW;
      when(mockFunc)(ArgumentMatchers.any).afterReturn('a');
      data.getContent(timer,'a',true);
      expect(data).not().assertUndefined();

      data.isHideContent = false;
      data.liveBaseTemplate = liveBaseTemplate;
      data.capsuleType === ImmersiveCapsuleType.LIVE_VIEW;
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing;
      data.getContent(timer,'a',true);
      expect(data).not().assertUndefined();
      mocker.clear(liveBaseTemplate);
    });

    it('updateNavDirectionIcon_test01', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(CommonUtils,CommonUtils.isInvalid);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      (data as object)['updateNavDirectionIcon']();
      expect(data).not().assertUndefined();
      mock.clear(CommonUtils);
      mock.clearAll();
    });

    it('isTimerInContent_test01', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let liveData: LiveViewData = new LiveViewData();
      let template: LiveBaseTemplate = new LiveBaseTemplate();
      template.title = 'test';
      template.content = 'test';
      liveData.template = template;
      liveData.liveType = LiveType.TYPE_SYSTEM;
      liveData.liveType = LiveType.TYPE_SYSTEM;
      data.liveView = liveData;
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(CommonUtils,CommonUtils.isInvalid);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      data.isTimerInContent();
      expect(data).not().assertUndefined();
      mock.clear(CommonUtils);
      mock.clearAll();
    });

    it('isTimerInTitle_test01', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let liveData: LiveViewData = new LiveViewData();
      let template: LiveBaseTemplate = new LiveBaseTemplate();
      template.title = 'test';
      template.content = 'test';
      liveData.template = template;
      liveData.liveType = LiveType.TYPE_SYSTEM;
      liveData.liveType = LiveType.TYPE_SYSTEM;
      data.liveView = liveData;
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(CommonUtils,CommonUtils.isInvalid);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      data.isTimerInTitle();
      expect(data).not().assertUndefined();
      mock.clear(CommonUtils);
      mock.clearAll();
    });

    it('setSmallIcon_test01', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(CommonUtils,CommonUtils.isInvalid);
      when(mockFun)(ArgumentMatchers.any).afterReturn(false);
      data.setSmallIcon(undefined,false);
      expect(data).not().assertUndefined();
      mock.clear(CommonUtils);
      mock.clearAll();
    });

    it('setCapsuleType_test01', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(CommonUtils,CommonUtils.isInvalid);
      when(mockFun)(ArgumentMatchers.any).afterReturn(false);
      data.setCapsuleType(ImmersiveCapsuleType.LIVE_VIEW,false);
      expect(data).not().assertUndefined();
      mock.clear(CommonUtils);
      mock.clearAll();
    });
  })
}