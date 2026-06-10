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
import { ILiveHeadsUpWalletCardVm } from '../../../../main/ets/live/interface/ILiveHeadsUpWalletCardVm';
import { LiveBaseVm } from '../../../../main/ets/live/vm/LiveBaseVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveNotification } from '../../../../main/ets/live/model/LiveNotification';
import {
  ImageInfo,
  NoAnchorPointOverallPageLayOutInfo,
  OverlayBoxInfo,
  RadioInfo,
  TextInfo
} from '../../../../main/ets/live/model/LiveCardWalletStatusInfoVm';
import { LiveCardSystemModel } from '../../../../main/ets/live/model/LiveCardSystemModel';
import { LiveHeadsUpWalletAnimation } from '../../../../main/ets/live/animation/LiveHeadsUpWalletAnimation';
import { AnimatorResult } from '@kit.ArkUI';
import { DeviceInfoVm } from '../../../../main/ets/vm/DeviceInfoVm';
import { CutoutVm } from '../../../../main/ets/statusbar/vm/CutoutVm';
import { LiveVmInjector } from '../../../../main/ets/live/LiveVmInjector';
import { ResourceVm } from '../../../../main/ets/vm/ResourceVm';
import { LiveHeadsUpWalletHoleAnimation } from '../../../../main/ets/live/animation/LiveHeadsUpWalletHoleAnimation';
import { LiveHeadsUpWalletNoHoleAnimation } from '../../../../main/ets/live/animation/LiveHeadsUpWalletNoHoleAnimation';
import { bannerMgr } from '../../../../main/ets/banner/phone/BannerManager';
import { BannerPanelType } from '../../../../main/ets/banner/common/info/BannerState';
import { LiveStyle } from '../../../../main/ets/live/constants/LiveStyle';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { LiveHeadsUpWalletCardVm } from '../../../../main/ets/live/vm/LiveHeadsUpWalletCardVm';

export default function LiveHeadsUpInfoWalletCardVmTest() {
  describe('show_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_reset_animationStage_and_sweepingStage_when_live_stage_is_SELECT_CARD', 0, async () => {
      let liveheadsupwalletcardvm: LiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let live: LiveNotification = new LiveNotification();
      live.stage = WalletStageValue.SELECT_CARD;
      live.card = new LiveCardSystemModel();
      live.smallIcon = new ImageInfo();
      let mocker: MockKit = new MockKit();


      await liveheadsupwalletcardvm.show(live);

      expect(liveheadsupwalletcardvm.animationStage).assertEqual(AnimationStage.INIT);
      expect(liveheadsupwalletcardvm.sweepingStage).assertEqual(SweepStage.NOT_DO);
      expect(liveheadsupwalletcardvm.imageInfo.cardimagePixelMap).assertEqual(live.smallIcon);

    });

    it('should_reset_animationStage_and_sweepingStage_when_live_stage_is_SWIPE_DOING', 0, async () => {
      let liveheadsupwalletcardvm: LiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let live: LiveNotification = new LiveNotification();
      live.stage = WalletStageValue.SWIPE_DOING;
      live.card = new LiveCardSystemModel();
      live.smallIcon = new ImageInfo();
      let mocker: MockKit = new MockKit();


      await liveheadsupwalletcardvm.show(live);

      expect(liveheadsupwalletcardvm.animationStage).assertEqual(AnimationStage.INIT);
      expect(liveheadsupwalletcardvm.sweepingStage).assertEqual(SweepStage.CAN_DO);
      expect(liveheadsupwalletcardvm.imageInfo.cardimagePixelMap).assertEqual(live.smallIcon);

    });

    it('should_update_ImageInfo_and_TextInfo_when_stage_is_SWIPE_SUCCEED', 0, async () => {
      let liveheadsupwalletcardvm: LiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockSetCardResponseRegion: Function =
        mocker.mockFunc(liveheadsupwalletcardvm, liveheadsupwalletcardvm.setCardResponseRegion);
      when(mockSetCardResponseRegion)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let mockLogHelperInfo: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockLogHelperInfo)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.stage = WalletStageValue.SWIPE_SUCCEED;
      live.card = new LiveCardSystemModel();
      live.card.title = 'testTitle';
      live.card.content = 'testContent';

      await liveheadsupwalletcardvm.update(live);

      expect(liveheadsupwalletcardvm.imageInfo.updateCardimagePixelMap).assertEqual(live.smallIcon);
      expect(liveheadsupwalletcardvm.textInfo.textMainTitle).assertEqual('testTitle');
      expect(liveheadsupwalletcardvm.textInfo.textSubTitle).assertEqual('testContent');

      mocker.ignoreMock(liveheadsupwalletcardvm, liveheadsupwalletcardvm.setCardResponseRegion);
      mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_update_ImageInfo_and_TextInfo_when_stage_is_SWIPE_FAILED', 0, async () => {
      let liveheadsupwalletcardvm: LiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockSetCardResponseRegion: Function =
        mocker.mockFunc(liveheadsupwalletcardvm, liveheadsupwalletcardvm.setCardResponseRegion);
      when(mockSetCardResponseRegion)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let mockLogHelperInfo: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockLogHelperInfo)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.stage = WalletStageValue.SWIPE_FAILED;
      live.card = new LiveCardSystemModel();
      live.card.title = 'testTitle';
      live.card.content = 'testContent';
      live.card.buttons = [{
        lightIcon: 'testIcon'
      }];

      await liveheadsupwalletcardvm.update(live);

      expect(liveheadsupwalletcardvm.imageInfo.updateCardimagePixelMap).assertEqual(live.smallIcon);
      expect(liveheadsupwalletcardvm.textInfo.textMainTitle).assertEqual('testTitle');
      expect(liveheadsupwalletcardvm.textInfo.textSubTitle).assertEqual('testContent');
      expect(liveheadsupwalletcardvm.radioInfo.isSwipeFailureIcon).assertTrue();
      expect(liveheadsupwalletcardvm.radioInfo.cardImageFailPixelMap).assertEqual('testIcon');

      mocker.ignoreMock(liveheadsupwalletcardvm, liveheadsupwalletcardvm.setCardResponseRegion);
      mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_call_swipeEnterRefreshImageAnimation_when_stage_is_SWIPE_DOING_and_isDoingRefresh_is_false', 0,
      async () => {
        let liveheadsupwalletcardvm: LiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
        let mocker: MockKit = new MockKit();

        let mockSetCardResponseRegion: Function =
          mocker.mockFunc(liveheadsupwalletcardvm, liveheadsupwalletcardvm.setCardResponseRegion);
        when(mockSetCardResponseRegion)(ArgumentMatchers.anyBoolean).afterReturnNothing();

        let mockLogHelperInfo: Function = mocker.mockFunc(LogHelper, LogHelper.info);
        when(mockLogHelperInfo)(ArgumentMatchers.any).afterReturnNothing();

        let mockSwipeEnterRefreshImageAnimation: Function = mocker.mockFunc(LiveHeadsUpWalletAnimation.prototype,
          LiveHeadsUpWalletAnimation.prototype.swipeEnterRefreshImageAnimation);
        when(mockSwipeEnterRefreshImageAnimation)().afterReturn(new AnimatorResult(true));

        let live: LiveNotification = new LiveNotification();
        live.stage = WalletStageValue.SWIPE_DOING;

        await liveheadsupwalletcardvm.update(live);

        mocker.ignoreMock(liveheadsupwalletcardvm, liveheadsupwalletcardvm.setCardResponseRegion);
        mocker.ignoreMock(LogHelper, LogHelper.info);
        mocker.ignoreMock(LiveHeadsUpWalletAnimation.prototype,
          LiveHeadsUpWalletAnimation.prototype.swipeEnterRefreshImageAnimation);
      });

    it('should_not_call_swipeEnterRefreshImageAnimation_when_stage_is_SWIPE_DOING_and_isDoingRefresh_is_true', 0,
      async () => {
        let liveheadsupwalletcardvm: LiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
        let mocker: MockKit = new MockKit();

        let mockSetCardResponseRegion: Function =
          mocker.mockFunc(liveheadsupwalletcardvm, liveheadsupwalletcardvm.setCardResponseRegion);
        when(mockSetCardResponseRegion)(ArgumentMatchers.anyBoolean).afterReturnNothing();

        let mockLogHelperInfo: Function = mocker.mockFunc(LogHelper, LogHelper.info);
        when(mockLogHelperInfo)(ArgumentMatchers.any).afterReturnNothing();

        let mockSwipeEnterRefreshImageAnimation: Function = mocker.mockFunc(LiveHeadsUpWalletAnimation.prototype,
          LiveHeadsUpWalletAnimation.prototype.swipeEnterRefreshImageAnimation);
        when(mockSwipeEnterRefreshImageAnimation)().afterReturn(new AnimatorResult(true));

        let live: LiveNotification = new LiveNotification();
        live.stage = WalletStageValue.SWIPE_DOING;
        liveheadsupwalletcardvm.live = new LiveNotification();
        liveheadsupwalletcardvm.live.stage = WalletStageValue.SWIPE_DOING;

        await liveheadsupwalletcardvm.update(live);

        mocker.ignoreMock(liveheadsupwalletcardvm, liveheadsupwalletcardvm.setCardResponseRegion);
        mocker.ignoreMock(LogHelper, LogHelper.info);
        mocker.ignoreMock(LiveHeadsUpWalletAnimation.prototype,
          LiveHeadsUpWalletAnimation.prototype.swipeEnterRefreshImageAnimation);
      });

    it('should_set_nextInstruction_to_SWIPE_FINISHED_when_stage_is_SWIPE_FINISHED', 0, async () => {
      let liveheadsupwalletcardvm: LiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let mockSetCardResponseRegion: Function =
        mocker.mockFunc(liveheadsupwalletcardvm, liveheadsupwalletcardvm.setCardResponseRegion);
      when(mockSetCardResponseRegion)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let mockLogHelperInfo: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockLogHelperInfo)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.stage = WalletStageValue.SWIPE_FINISHED;

      await liveheadsupwalletcardvm.update(live);

      expect(liveheadsupwalletcardvm.imageInfo.nextInstruction).assertEqual(WalletStageValue.SWIPE_FINISHED);

      mocker.ignoreMock(liveheadsupwalletcardvm, liveheadsupwalletcardvm.setCardResponseRegion);
      mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_set_imageInfo_nextInstruction_to_SWIPE_FINISHED_when_nextInstruction_is_minus_one', 0, async () => {
      let liveheadsupwalletcardvm: LiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      liveheadsupwalletcardvm.imageInfo.nextInstruction = -1;
      await liveheadsupwalletcardvm.hide();
      expect(liveheadsupwalletcardvm.imageInfo.nextInstruction).assertEqual(WalletStageValue.SWIPE_FINISHED);
    });

    it('should_not_set_imageInfo_nextInstruction_to_SWIPE_FINISHED_when_nextInstruction_is_not_minus_one', 0,
      async () => {
        let liveheadsupwalletcardvm: LiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
        liveheadsupwalletcardvm.imageInfo.nextInstruction = 0;
        await liveheadsupwalletcardvm.hide();
        expect(liveheadsupwalletcardvm.imageInfo.nextInstruction).assertEqual(0);
      });

    it('should_call_swipeExitEndAnimation_when_animation_is_not_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();
      let liveheadsupwalletcardvm: LiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let mockfunc: Function =
        mocker.mockFunc(liveheadsupwalletcardvm.animation, liveheadsupwalletcardvm.animation.swipeExitEndAnimation);
      await liveheadsupwalletcardvm.hide();
      expect(liveheadsupwalletcardvm.isRotated).assertEqual(false);
    });

    it('should_not_call_swipeExitEndAnimation_when_animation_is_undefined', 0, async () => {
      let liveheadsupwalletcardvm: LiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      liveheadsupwalletcardvm.animation = undefined;
      await liveheadsupwalletcardvm.hide();
      expect(liveheadsupwalletcardvm.isRotated).assertEqual(false);
    });

    it('should_return_false_when_lastHashCode_equals_live_hashCode_and_showStage_is_HIDE', 0, () => {
      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      liveheadsupwalletcardvm.lastHashCode = '12345';
      liveheadsupwalletcardvm.showStage = ShowStage.HIDE;
      const result = liveheadsupwalletcardvm.isNeedShow(live);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_lastHashCode_not_equals_live_hashCode_or_showStage_is_not_HIDE', 0, () => {
      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      liveheadsupwalletcardvm.lastHashCode = '54321';
      liveheadsupwalletcardvm.showStage = ShowStage.SHOW;
      const result = liveheadsupwalletcardvm.isNeedShow(live);
      expect(result).assertEqual(true);
    });


    it('should_return_immediately_when_live_is_undefined', 0, () => {
      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      liveheadsupwalletcardvm.setCardResponseRegion();
    });

    it('should_return_immediately_when_bannerMgr_is_not_TYPE_LIVE_HEADS_UP', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);

      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      liveheadsupwalletcardvm.setCardResponseRegion();

      mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    });

    it('should_set_isRotated_to_true_when_isRotate_is_true', 0, () => {
      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      liveheadsupwalletcardvm.setCardResponseRegion(true);
      expect(liveheadsupwalletcardvm.isRotated).assertTrue();
    });

    it('should_set_response_area_to_middle_when_isMiddleCutout_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
      when(mockfunc)([]).afterReturn(true);

      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      liveheadsupwalletcardvm.setCardResponseRegion();

      mocker.ignoreMock(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
    });

    it('should_set_response_area_to_landscape_when_isMiddleCutout_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
      when(mockfunc)([]).afterReturn(false);

      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      liveheadsupwalletcardvm.setCardResponseRegion();

      mocker.ignoreMock(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
    });

    it('should_return_3_when_fontScale_is_less_than_or_equal_to_1', 0, () => {
      ResourceVm.instance.fontScale = 1;
      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let result = liveheadsupwalletcardvm.getBigFontOffsetY();
      expect(result).assertEqual(3);
    });

    it('should_return_0_5_when_fontScale_is_less_than_1.3', 0, () => {
      ResourceVm.instance.fontScale = 1.2;
      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let result = liveheadsupwalletcardvm.getBigFontOffsetY();
      expect(result).assertEqual(0.5);
    });

    it('should_return_negative_2_7_when_fontScale_is_less_than_1.45', 0, () => {
      ResourceVm.instance.fontScale = 1.44;
      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let result = liveheadsupwalletcardvm.getBigFontOffsetY();
      expect(result).assertEqual(-2.7);
    });

    it('should_return_negative_5_55_when_fontScale_is_less_than_1.45', 0, () => {
      ResourceVm.instance.fontScale = 1.45;
      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let result = liveheadsupwalletcardvm.getBigFontOffsetY();
      expect(result).assertEqual(-5.55);
    });

    it('should_return_66_when_fontScale_is_less_than_or_equal_to_1', 0, () => {
      ResourceVm.instance.fontScale = 1;
      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let result = liveheadsupwalletcardvm.getLargeFontAdaptationHeight();
      expect(result).assertEqual(66);
    });

    it('should_return_71_4_when_fontScale_is_less_than_1.3', 0, () => {
      ResourceVm.instance.fontScale = 1.2;
      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let result = liveheadsupwalletcardvm.getLargeFontAdaptationHeight();
      expect(result).assertEqual(71.4);
    });

    it('should_return_77_4_when_fontScale_is_less_than_1.45', 0, () => {
      ResourceVm.instance.fontScale = 1.44;
      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let result = liveheadsupwalletcardvm.getLargeFontAdaptationHeight();
      expect(result).assertEqual(77.4);
    });

    it('should_return_83_1_when_fontScale_is_greater_than_or_equal_to_1.45', 0, () => {
      ResourceVm.instance.fontScale = 1.45;
      let liveheadsupwalletcardvm: ILiveHeadsUpWalletCardVm = new LiveHeadsUpWalletCardVm(new LiveVmInjector());
      let result = liveheadsupwalletcardvm.getLargeFontAdaptationHeight();
      expect(result).assertEqual(83.1);
    });

    it('should_toggle_capsule_list_when_creator_uid_is_different', 0, async () => {
      let livemediaplayervm: LiveMediaPlayerVm = new LiveMediaPlayerVm();
      let live: LiveNotification = new LiveNotification();
      live.creatorUid = 'uid1';
      livemediaplayervm.live = {
        creatorUid: 'uid2'
      };
      let mocker: MockKit = new MockKit();
      let mockCapsuleListVm: LiveCapsuleVm = new LiveCapsuleVm();
      let mockGetCapsuleListVm: Function =
        mocker.mockFunc(livemediaplayervm.vmInjector, livemediaplayervm.vmInjector.getCapsuleListVm);
      when(mockGetCapsuleListVm)([]).afterReturn(mockCapsuleListVm);
      let mockUpdateIconAnimation: Function = mocker.mockFunc(livemediaplayervm.liveMediaPlayerAnimation,
        livemediaplayervm.liveMediaPlayerAnimation.updateIconAnimation);
      when(mockUpdateIconAnimation)([ArgumentMatchers.any]).afterReturn(Promise.resolve());

      await livemediaplayervm.updateMedia(live);

      expect(livemediaplayervm.oldMediaIcon).assertUndefined();
      mocker.ignoreMock(livemediaplayervm.vmInjector, livemediaplayervm.vmInjector.getCapsuleListVm);
      mocker.ignoreMock(livemediaplayervm.liveMediaPlayerAnimation,
        livemediaplayervm.liveMediaPlayerAnimation.updateIconAnimation);
    });

    it('should_update_icon_animation_when_icon_animation_type_is_animate', 0, async () => {
      let livemediaplayervm: LiveMediaPlayerVm = new LiveMediaPlayerVm();
      let live: LiveNotification = new LiveNotification();
      live.creatorUid = 'uid1';
      live.capsule = {
        iconAnimationType: LiveCapsuleIconAnimationType.Animate
      };
      livemediaplayervm.live = {
        creatorUid: 'uid1'
      };
      let mocker: MockKit = new MockKit();
      let mockCapsuleListVm: LiveCapsuleVm = new LiveCapsuleVm();
      let mockGetCapsuleListVm: Function =
        mocker.mockFunc(livemediaplayervm.vmInjector, livemediaplayervm.vmInjector.getCapsuleListVm);
      when(mockGetCapsuleListVm)([]).afterReturn(mockCapsuleListVm);
      let mockUpdateIconAnimation: Function = mocker.mockFunc(livemediaplayervm.liveMediaPlayerAnimation,
        livemediaplayervm.liveMediaPlayerAnimation.updateIconAnimation);
      when(mockUpdateIconAnimation)([ArgumentMatchers.any]).afterReturn(Promise.resolve());

      await livemediaplayervm.updateMedia(live);

      expect(livemediaplayervm.oldMediaIcon).assertUndefined();
      mocker.ignoreMock(livemediaplayervm.vmInjector, livemediaplayervm.vmInjector.getCapsuleListVm);
      mocker.ignoreMock(livemediaplayervm.liveMediaPlayerAnimation,
        livemediaplayervm.liveMediaPlayerAnimation.updateIconAnimation);
    });

    it('should_not_update_icon_animation_when_icon_animation_type_is_not_animate', 0, async () => {
      let livemediaplayervm: LiveMediaPlayerVm = new LiveMediaPlayerVm();
      let live: LiveNotification = new LiveNotification();
      live.creatorUid = 'uid1';
      live.capsule = {
        iconAnimationType: LiveCapsuleIconAnimationType.None
      };
      livemediaplayervm.live = {
        creatorUid: 'uid1'
      };
      let mocker: MockKit = new MockKit();
      let mockCapsuleListVm: LiveCapsuleVm = new LiveCapsuleVm();
      let mockGetCapsuleListVm: Function =
        mocker.mockFunc(livemediaplayervm.vmInjector, livemediaplayervm.vmInjector.getCapsuleListVm);
      when(mockGetCapsuleListVm)([]).afterReturn(mockCapsuleListVm);
      let mockUpdateIconAnimation: Function = mocker.mockFunc(livemediaplayervm.liveMediaPlayerAnimation,
        livemediaplayervm.liveMediaPlayerAnimation.updateIconAnimation);
      when(mockUpdateIconAnimation)([ArgumentMatchers.any]).afterReturn(Promise.resolve());

      await livemediaplayervm.updateMedia(live);

      expect(livemediaplayervm.oldMediaIcon).assertUndefined();
      mocker.ignoreMock(livemediaplayervm.vmInjector, livemediaplayervm.vmInjector.getCapsuleListVm);
      mocker.ignoreMock(livemediaplayervm.liveMediaPlayerAnimation,
        livemediaplayervm.liveMediaPlayerAnimation.updateIconAnimation);
    });

    it('should_sleep_for_duration_when_icon_animation_type_is_animate', 0, async () => {
      let livemediaplayervm: LiveMediaPlayerVm = new LiveMediaPlayerVm();
      let live: LiveNotification = new LiveNotification();
      live.creatorUid = 'uid1';
      live.capsule = {
        iconAnimationType: LiveCapsuleIconAnimationType.Animate
      };
      livemediaplayervm.live = {
        creatorUid: 'uid1'
      };
      let mocker: MockKit = new MockKit();
      let mockCapsuleListVm: LiveCapsuleVm = new LiveCapsuleVm();
      let mockGetCapsuleListVm: Function =
        mocker.mockFunc(livemediaplayervm.vmInjector, livemediaplayervm.vmInjector.getCapsuleListVm);
      when(mockGetCapsuleListVm)([]).afterReturn(mockCapsuleListVm);
      let mockUpdateIconAnimation: Function = mocker.mockFunc(livemediaplayervm.liveMediaPlayerAnimation,
        livemediaplayervm.liveMediaPlayerAnimation.updateIconAnimation);
      when(mockUpdateIconAnimation)([ArgumentMatchers.any]).afterReturn(Promise.resolve());

      await livemediaplayervm.updateMedia(live);

      expect(livemediaplayervm.oldMediaIcon).assertUndefined();
      mocker.ignoreMock(livemediaplayervm.vmInjector, livemediaplayervm.vmInjector.getCapsuleListVm);
      mocker.ignoreMock(livemediaplayervm.liveMediaPlayerAnimation,
        livemediaplayervm.liveMediaPlayerAnimation.updateIconAnimation);
    });
  });
}