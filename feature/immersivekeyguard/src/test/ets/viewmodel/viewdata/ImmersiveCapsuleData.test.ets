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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, Level, it } from '@ohos/hypium';
import {
  ImmersiveCapsuleType,
  LiveType,
  LiveViewData,
  LiveTimerData,
  ImmersiveShowType
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ImmersiveCapsuleData } from '../../../../main/ets/viewmodel/viewdata/ImmersiveCapsuleData';

export function ImmersiveCapsuleDataTest1() {

  describe('ImmersiveCapsuleDataTest1', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_isLiveCapsule1', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isLiveCapsule();
      expect(res).assertTrue();
    });

    it('test_isSysLiveType1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isSysLiveType();
      expect(res).assertTrue();
    });

    it('test_isMediaPlay1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isMediaPlay();
      expect(res).assertTrue();
    });

    it('test_isProgressType1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isProgressType();
      expect(res).assertTrue();
    });

    it('test_shouldShowInImmersiveCard1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.shouldShowInImmersiveCard();
      expect(res).assertTrue();
    });

    it('test_hasOverlayIcon1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasOverlayIcon();
      data.isHideContent = false;
      data.hasOverlayIcon();
      expect(res).assertTrue();
    });

    it('test_getLargeIcon1001', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.getLargeIcon();
      data.isHideContent = false;
      data.getLargeIcon();
      data.isHideContent = true;
      data.getLargeIcon();
    });

    it('test_getSmallIcon1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getSmallIcon();
      data.liveType = LiveType.NAVIGATION;
      data.getSmallIcon();
      data.smallIcon = 'test1';
      data.getSmallIcon();
      data.appIcon = 'test1';
      data.getSmallIcon();
      expect(res).assertTrue();
    });

    it('test_hasProgress1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasProgress();
      expect(res).assertTrue();
    });

    it('test_hasButton1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasButton();
      expect(res).assertTrue();
    });

    it('test_getButtonData1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getButtonData();
      expect(res).assertTrue();
    });

    it('test_hasOther1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasOther();
      expect(res).assertTrue();
    });

    it('test_hasTimer1001', Level.LEVEL0, (): void => {
      let data1 = new ImmersiveCapsuleData();
      data1.hasTimer();
      data1.capsuleType = ImmersiveCapsuleType.LIVE_VIEW;
      data1.liveTimer = undefined;
      data1.hasTimer();
      data1.liveTimer = new LiveTimerData();
      data1.hasTimer();
    });

    it('test_isShowGroupStyle1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isShowGroupStyle();
      expect(res).assertTrue();
    });

    it('test_getTitle1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getTitle();
      data.isHideContent = true;
      data.getTitle();
      data.appName = 'test1';
      data.getTitle();
      expect(res).assertTrue();
    });

    it('test_createGroup1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.createGroup();
      expect(res).assertTrue();
    });

    it('test_deleteGroup1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.deleteGroup();
      expect(res).assertTrue();
    });

    it('test_setTitle1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setTitle();
      data.setTitle('test');
      data.setTitle('test', true);
      expect(res).assertTrue();
    });

    it('test_setContent1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setContent();
      data.setContent('test1');
      data.setContent('test1', true);
      expect(res).assertTrue();
    });

    it('test_setCapsuleType1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setCapsuleType(ImmersiveCapsuleType.LIVE_VIEW);
      expect(res).assertTrue();
    });

    it('test_setOverlayIcon1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setOverlayIcon();
      data.setOverlayIcon(null, true);
      expect(res).assertTrue();
    });

    it('test_refreshChildrenCount1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.refreshChildrenCount();
      data.addChildData(new ImmersiveCapsuleData());
      data.refreshChildrenCount();
      expect(res).assertTrue();
    });

    it('test_setLiveView1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setLiveView();
      expect(res).assertTrue();
    });

    it('test_setProgressType1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setProgressType();
      data.setProgressType(true);
      expect(res).assertTrue();
    });

    it('test_update1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.update(new ImmersiveCapsuleData());
      data.update(new ImmersiveCapsuleData(), true);
      expect(res).assertTrue();
    });

    it('test_setTest1001', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setShowType(ImmersiveShowType.NOT_SHOW);
      data.setShowType(ImmersiveShowType.SHOW_CAPSULE);
      data.setShowType(ImmersiveShowType.SHOW_CARD);
      data.setHashCode('hashcode1');
      data.setGroupKey('groupKey1');
    });

    it('test_toString1001', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.toString();
      expect(res).assertTrue();
    });

    it('test_isSysLiveType1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isSysLiveType();
      expect(res).assertTrue();
    });

    it('test_isMediaPlay1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isMediaPlay();
      expect(res).assertTrue();
    });

    it('test_isProgressType1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isProgressType();
      expect(res).assertTrue();
    });

    it('test_shouldShowInImmersiveCard1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.shouldShowInImmersiveCard();
      expect(res).assertTrue();
    });

    it('test_hasOverlayIcon1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasOverlayIcon();
      data.isHideContent = false;
      data.hasOverlayIcon();
      expect(res).assertTrue();
    });

    it('test_getLargeIcon1002', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.getLargeIcon();
      data.isHideContent = false;
      data.getLargeIcon();
      data.isHideContent = true;
      data.getLargeIcon();
    });

    it('test_getSmallIcon1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getSmallIcon();
      data.liveType = LiveType.NAVIGATION;
      data.getSmallIcon();
      data.smallIcon = 'test1';
      data.getSmallIcon();
      data.appIcon = 'test1';
      data.getSmallIcon();
      expect(res).assertTrue();
    });

    it('test_hasProgress1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasProgress();
      expect(res).assertTrue();
    });

    it('test_hasButton1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasButton();
      expect(res).assertTrue();
    });

    it('test_getButtonData1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getButtonData();
      expect(res).assertTrue();
    });

    it('test_hasOther1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasOther();
      expect(res).assertTrue();
    });

    it('test_hasTimer1002', Level.LEVEL0, (): void => {
      let data1 = new ImmersiveCapsuleData();
      data1.hasTimer();
      data1.capsuleType = ImmersiveCapsuleType.LIVE_VIEW;
      data1.liveTimer = undefined;
      data1.hasTimer();
      data1.liveTimer = new LiveTimerData();
      data1.hasTimer();
    });

    it('test_isShowGroupStyle1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isShowGroupStyle();
      expect(res).assertTrue();
    });

    it('test_getTitle1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getTitle();
      data.isHideContent = true;
      data.getTitle();
      data.appName = 'test1';
      data.getTitle();
      expect(res).assertTrue();
    });

    it('test_createGroup1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.createGroup();
      expect(res).assertTrue();
    });

    it('test_deleteGroup1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.deleteGroup();
      expect(res).assertTrue();
    });

    it('test_setTitle1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setTitle();
      data.setTitle('test');
      data.setTitle('test', true);
      expect(res).assertTrue();
    });

    it('test_setContent1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setContent();
      data.setContent('test1');
      data.setContent('test1', true);
      expect(res).assertTrue();
    });

    it('test_setCapsuleType1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setCapsuleType(ImmersiveCapsuleType.LIVE_VIEW);
      expect(res).assertTrue();
    });

    it('test_setOverlayIcon1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setOverlayIcon();
      data.setOverlayIcon(null, true);
      expect(res).assertTrue();
    });

    it('test_refreshChildrenCount1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.refreshChildrenCount();
      data.addChildData(new ImmersiveCapsuleData());
      data.refreshChildrenCount();
      expect(res).assertTrue();
    });

    it('test_setLiveView1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setLiveView();
      expect(res).assertTrue();
    });

    it('test_setProgressType1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setProgressType();
      data.setProgressType(true);
      expect(res).assertTrue();
    });

    it('test_update1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.update(new ImmersiveCapsuleData());
      data.update(new ImmersiveCapsuleData(), true);
      expect(res).assertTrue();
    });

    it('test_setTest1002', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setShowType(ImmersiveShowType.NOT_SHOW);
      data.setShowType(ImmersiveShowType.SHOW_CAPSULE);
      data.setShowType(ImmersiveShowType.SHOW_CARD);
      data.setHashCode('hashcode1');
      data.setGroupKey('groupKey1');
    });

    it('test_toString1002', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.toString();
      expect(res).assertTrue();
    });

    it('test_isSysLiveType1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isSysLiveType();
      expect(res).assertTrue();
    });

    it('test_isMediaPlay1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isMediaPlay();
      expect(res).assertTrue();
    });

    it('test_isProgressType1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isProgressType();
      expect(res).assertTrue();
    });

    it('test_shouldShowInImmersiveCard1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.shouldShowInImmersiveCard();
      expect(res).assertTrue();
    });

    it('test_hasOverlayIcon1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasOverlayIcon();
      data.isHideContent = false;
      data.hasOverlayIcon();
      expect(res).assertTrue();
    });

    it('test_getLargeIcon1003', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.getLargeIcon();
      data.isHideContent = false;
      data.getLargeIcon();
      data.isHideContent = true;
      data.getLargeIcon();
    });

    it('test_getSmallIcon1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getSmallIcon();
      data.liveType = LiveType.NAVIGATION;
      data.getSmallIcon();
      data.smallIcon = 'test1';
      data.getSmallIcon();
      data.appIcon = 'test1';
      data.getSmallIcon();
      expect(res).assertTrue();
    });

    it('test_hasProgress1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasProgress();
      expect(res).assertTrue();
    });

    it('test_hasButton1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasButton();
      expect(res).assertTrue();
    });

    it('test_getButtonData1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getButtonData();
      expect(res).assertTrue();
    });

    it('test_hasOther1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasOther();
      expect(res).assertTrue();
    });

    it('test_hasTimer1003', Level.LEVEL0, (): void => {
      let data1 = new ImmersiveCapsuleData();
      data1.hasTimer();
      data1.capsuleType = ImmersiveCapsuleType.LIVE_VIEW;
      data1.liveTimer = undefined;
      data1.hasTimer();
      data1.liveTimer = new LiveTimerData();
      data1.hasTimer();
    });

    it('test_isShowGroupStyle1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isShowGroupStyle();
      expect(res).assertTrue();
    });

    it('test_getTitle1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getTitle();
      data.isHideContent = true;
      data.getTitle();
      data.appName = 'test1';
      data.getTitle();
      expect(res).assertTrue();
    });

    it('test_createGroup1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.createGroup();
      expect(res).assertTrue();
    });

    it('test_deleteGroup1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.deleteGroup();
      expect(res).assertTrue();
    });

    it('test_setTitle1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setTitle();
      data.setTitle('test');
      data.setTitle('test', true);
      expect(res).assertTrue();
    });

    it('test_setContent1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setContent();
      data.setContent('test1');
      data.setContent('test1', true);
      expect(res).assertTrue();
    });

    it('test_setCapsuleType1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setCapsuleType(ImmersiveCapsuleType.LIVE_VIEW);
      expect(res).assertTrue();
    });

    it('test_setOverlayIcon1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setOverlayIcon();
      data.setOverlayIcon(null, true);
      expect(res).assertTrue();
    });

    it('test_refreshChildrenCount1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.refreshChildrenCount();
      data.addChildData(new ImmersiveCapsuleData());
      data.refreshChildrenCount();
      expect(res).assertTrue();
    });

    it('test_setLiveView1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setLiveView();
      expect(res).assertTrue();
    });

    it('test_setProgressType1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setProgressType();
      data.setProgressType(true);
      expect(res).assertTrue();
    });

    it('test_update1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.update(new ImmersiveCapsuleData());
      data.update(new ImmersiveCapsuleData(), true);
      expect(res).assertTrue();
    });

    it('test_setTest1003', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setShowType(ImmersiveShowType.NOT_SHOW);
      data.setShowType(ImmersiveShowType.SHOW_CAPSULE);
      data.setShowType(ImmersiveShowType.SHOW_CARD);
      data.setHashCode('hashcode1');
      data.setGroupKey('groupKey1');
    });

    it('test_toString1003', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.toString();
      expect(res).assertTrue();
    });

    it('test_isSysLiveType1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isSysLiveType();
      expect(res).assertTrue();
    });

    it('test_isMediaPlay1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isMediaPlay();
      expect(res).assertTrue();
    });

    it('test_isProgressType1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isProgressType();
      expect(res).assertTrue();
    });

    it('test_shouldShowInImmersiveCard1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.shouldShowInImmersiveCard();
      expect(res).assertTrue();
    });

    it('test_hasOverlayIcon1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasOverlayIcon();
      data.isHideContent = false;
      data.hasOverlayIcon();
      expect(res).assertTrue();
    });

    it('test_getLargeIcon1004', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.getLargeIcon();
      data.isHideContent = false;
      data.getLargeIcon();
      data.isHideContent = true;
      data.getLargeIcon();
    });

    it('test_getSmallIcon1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getSmallIcon();
      data.liveType = LiveType.NAVIGATION;
      data.getSmallIcon();
      data.smallIcon = 'test1';
      data.getSmallIcon();
      data.appIcon = 'test1';
      data.getSmallIcon();
      expect(res).assertTrue();
    });

    it('test_hasProgress1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasProgress();
      expect(res).assertTrue();
    });

    it('test_hasButton1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasButton();
      expect(res).assertTrue();
    });

    it('test_getButtonData1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getButtonData();
      expect(res).assertTrue();
    });

    it('test_hasOther1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasOther();
      expect(res).assertTrue();
    });

    it('test_hasTimer1004', Level.LEVEL0, (): void => {
      let data1 = new ImmersiveCapsuleData();
      data1.hasTimer();
      data1.capsuleType = ImmersiveCapsuleType.LIVE_VIEW;
      data1.liveTimer = undefined;
      data1.hasTimer();
      data1.liveTimer = new LiveTimerData();
      data1.hasTimer();
    });

    it('test_isShowGroupStyle1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isShowGroupStyle();
      expect(res).assertTrue();
    });

    it('test_getTitle1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getTitle();
      data.isHideContent = true;
      data.getTitle();
      data.appName = 'test1';
      data.getTitle();
      expect(res).assertTrue();
    });

    it('test_createGroup1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.createGroup();
      expect(res).assertTrue();
    });

    it('test_deleteGroup1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.deleteGroup();
      expect(res).assertTrue();
    });

    it('test_setTitle1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setTitle();
      data.setTitle('test');
      data.setTitle('test', true);
      expect(res).assertTrue();
    });

    it('test_setContent1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setContent();
      data.setContent('test1');
      data.setContent('test1', true);
      expect(res).assertTrue();
    });

    it('test_setCapsuleType1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setCapsuleType(ImmersiveCapsuleType.LIVE_VIEW);
      expect(res).assertTrue();
    });

    it('test_setOverlayIcon1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setOverlayIcon();
      data.setOverlayIcon(null, true);
      expect(res).assertTrue();
    });

    it('test_refreshChildrenCount1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.refreshChildrenCount();
      data.addChildData(new ImmersiveCapsuleData());
      data.refreshChildrenCount();
      expect(res).assertTrue();
    });

    it('test_setLiveView1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setLiveView();
      expect(res).assertTrue();
    });

    it('test_setProgressType1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setProgressType();
      data.setProgressType(true);
      expect(res).assertTrue();
    });

    it('test_update1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.update(new ImmersiveCapsuleData());
      data.update(new ImmersiveCapsuleData(), true);
      expect(res).assertTrue();
    });

    it('test_setTest1004', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setShowType(ImmersiveShowType.NOT_SHOW);
      data.setShowType(ImmersiveShowType.SHOW_CAPSULE);
      data.setShowType(ImmersiveShowType.SHOW_CARD);
      data.setHashCode('hashcode1');
      data.setGroupKey('groupKey1');
    });

    it('test_toString1004', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.toString();
      expect(res).assertTrue();
    });

    it('test_isSysLiveType1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isSysLiveType();
      expect(res).assertTrue();
    });

    it('test_isMediaPlay1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isMediaPlay();
      expect(res).assertTrue();
    });

    it('test_isProgressType1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isProgressType();
      expect(res).assertTrue();
    });

    it('test_shouldShowInImmersiveCard1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.shouldShowInImmersiveCard();
      expect(res).assertTrue();
    });

    it('test_hasOverlayIcon1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasOverlayIcon();
      data.isHideContent = false;
      data.hasOverlayIcon();
      expect(res).assertTrue();
    });

    it('test_getLargeIcon1005', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.getLargeIcon();
      data.isHideContent = false;
      data.getLargeIcon();
      data.isHideContent = true;
      data.getLargeIcon();
    });

    it('test_getSmallIcon1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getSmallIcon();
      data.liveType = LiveType.NAVIGATION;
      data.getSmallIcon();
      data.smallIcon = 'test1';
      data.getSmallIcon();
      data.appIcon = 'test1';
      data.getSmallIcon();
      expect(res).assertTrue();
    });

    it('test_hasProgress1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasProgress();
      expect(res).assertTrue();
    });

    it('test_hasButton1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasButton();
      expect(res).assertTrue();
    });

    it('test_getButtonData1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getButtonData();
      expect(res).assertTrue();
    });

    it('test_hasOther1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasOther();
      expect(res).assertTrue();
    });

    it('test_hasTimer1005', Level.LEVEL0, (): void => {
      let data1 = new ImmersiveCapsuleData();
      data1.hasTimer();
      data1.capsuleType = ImmersiveCapsuleType.LIVE_VIEW;
      data1.liveTimer = undefined;
      data1.hasTimer();
      data1.liveTimer = new LiveTimerData();
      data1.hasTimer();
    });

    it('test_isShowGroupStyle1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isShowGroupStyle();
      expect(res).assertTrue();
    });

    it('test_getTitle1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getTitle();
      data.isHideContent = true;
      data.getTitle();
      data.appName = 'test1';
      data.getTitle();
      expect(res).assertTrue();
    });

    it('test_createGroup1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.createGroup();
      expect(res).assertTrue();
    });

    it('test_deleteGroup1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.deleteGroup();
      expect(res).assertTrue();
    });

    it('test_setTitle1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setTitle();
      data.setTitle('test');
      data.setTitle('test', true);
      expect(res).assertTrue();
    });

    it('test_setContent1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setContent();
      data.setContent('test1');
      data.setContent('test1', true);
      expect(res).assertTrue();
    });

    it('test_setCapsuleType1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setCapsuleType(ImmersiveCapsuleType.LIVE_VIEW);
      expect(res).assertTrue();
    });

    it('test_setOverlayIcon1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setOverlayIcon();
      data.setOverlayIcon(null, true);
      expect(res).assertTrue();
    });

    it('test_refreshChildrenCount1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.refreshChildrenCount();
      data.addChildData(new ImmersiveCapsuleData());
      data.refreshChildrenCount();
      expect(res).assertTrue();
    });

    it('test_setLiveView1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setLiveView();
      expect(res).assertTrue();
    });

    it('test_setProgressType1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setProgressType();
      data.setProgressType(true);
      expect(res).assertTrue();
    });

    it('test_update1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.update(new ImmersiveCapsuleData());
      data.update(new ImmersiveCapsuleData(), true);
      expect(res).assertTrue();
    });

    it('test_setTest1005', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setShowType(ImmersiveShowType.NOT_SHOW);
      data.setShowType(ImmersiveShowType.SHOW_CAPSULE);
      data.setShowType(ImmersiveShowType.SHOW_CARD);
      data.setHashCode('hashcode1');
      data.setGroupKey('groupKey1');
    });

    it('test_toString1005', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.toString();
      expect(res).assertTrue();
    });

    it('test_isSysLiveType1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isSysLiveType();
      expect(res).assertTrue();
    });

    it('test_isMediaPlay1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isMediaPlay();
      expect(res).assertTrue();
    });

    it('test_isProgressType1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isProgressType();
      expect(res).assertTrue();
    });

    it('test_shouldShowInImmersiveCard1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.shouldShowInImmersiveCard();
      expect(res).assertTrue();
    });

    it('test_hasOverlayIcon1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasOverlayIcon();
      data.isHideContent = false;
      data.hasOverlayIcon();
      expect(res).assertTrue();
    });

    it('test_getLargeIcon1006', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.getLargeIcon();
      data.isHideContent = false;
      data.getLargeIcon();
      data.isHideContent = true;
      data.getLargeIcon();
    });

    it('test_getSmallIcon1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getSmallIcon();
      data.liveType = LiveType.NAVIGATION;
      data.getSmallIcon();
      data.smallIcon = 'test1';
      data.getSmallIcon();
      data.appIcon = 'test1';
      data.getSmallIcon();
      expect(res).assertTrue();
    });

    it('test_hasProgress1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasProgress();
      expect(res).assertTrue();
    });

    it('test_hasButton1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasButton();
      expect(res).assertTrue();
    });

    it('test_getButtonData1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getButtonData();
      expect(res).assertTrue();
    });

    it('test_hasOther1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.hasOther();
      expect(res).assertTrue();
    });

    it('test_hasTimer1006', Level.LEVEL0, (): void => {
      let data1 = new ImmersiveCapsuleData();
      data1.hasTimer();
      data1.capsuleType = ImmersiveCapsuleType.LIVE_VIEW;
      data1.liveTimer = undefined;
      data1.hasTimer();
      data1.liveTimer = new LiveTimerData();
      data1.hasTimer();
    });

    it('test_isShowGroupStyle1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.isShowGroupStyle();
      expect(res).assertTrue();
    });

    it('test_getTitle1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.getTitle();
      data.isHideContent = true;
      data.getTitle();
      data.appName = 'test1';
      data.getTitle();
      expect(res).assertTrue();
    });

    it('test_createGroup1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.createGroup();
      expect(res).assertTrue();
    });

    it('test_deleteGroup1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.deleteGroup();
      expect(res).assertTrue();
    });

    it('test_setTitle1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setTitle();
      data.setTitle('test');
      data.setTitle('test', true);
      expect(res).assertTrue();
    });

    it('test_setContent1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.addChildData(new ImmersiveCapsuleData());
      data.setContent();
      data.setContent('test1');
      data.setContent('test1', true);
      expect(res).assertTrue();
    });

    it('test_setCapsuleType1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setCapsuleType(ImmersiveCapsuleType.LIVE_VIEW);
      expect(res).assertTrue();
    });

    it('test_setOverlayIcon1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setOverlayIcon();
      data.setOverlayIcon(null, true);
      expect(res).assertTrue();
    });

    it('test_refreshChildrenCount1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.refreshChildrenCount();
      data.addChildData(new ImmersiveCapsuleData());
      data.refreshChildrenCount();
      expect(res).assertTrue();
    });

    it('test_setLiveView1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setLiveView();
      expect(res).assertTrue();
    });

    it('test_setProgressType1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.setProgressType();
      data.setProgressType(true);
      expect(res).assertTrue();
    });

    it('test_update1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.update(new ImmersiveCapsuleData());
      data.update(new ImmersiveCapsuleData(), true);
      expect(res).assertTrue();
    });

    it('test_setTest1006', Level.LEVEL0, (): void => {
      let data = new ImmersiveCapsuleData();
      data.setShowType(ImmersiveShowType.NOT_SHOW);
      data.setShowType(ImmersiveShowType.SHOW_CAPSULE);
      data.setShowType(ImmersiveShowType.SHOW_CARD);
      data.setHashCode('hashcode1');
      data.setGroupKey('groupKey1');
    });

    it('test_toString1006', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleData();
      data.toString();
      expect(res).assertTrue();
    });
  })
}