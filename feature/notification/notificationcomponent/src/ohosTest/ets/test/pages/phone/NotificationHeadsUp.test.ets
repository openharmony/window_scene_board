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

import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import {
  CommonUtils,
  LogDomain,
  LogHelper,
  Trace,
  ArrayUtils
} from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { baseStateMgr,
  CardScaleType,
  CardScaleUtil,
  FrameCount, ImmersiveBaseState, StateType, SystemUICommonUtil } from '@ohos/systemuicommon';
import { LiveUseScene, BannerDeformState, LiveViewData } from '@ohos/systemuicommon';
import { NtfAppIconModifier } from '../../../../main/ets/vm/style/NtfAppIconModifier';
import { NtfCloseVM } from '../../../../main/ets/vm/NtfCloseVM';
import { BannerFloatingController } from '../../../../main/ets/controller/BannerFloatingController';
import { RootCard } from '@ohos/systemuicommon/Index';
import { NotificationContentInTint } from '../../../../main/ets/pages/phone/NotificationContentInTint';
import { NotificationContent } from '../../../../main/ets/pages/phone/NotificationContent';
import { NtfTimeVM } from '../../../../main/ets/vm/NtfTimeVM';
import { NotificationConfig } from '../../../../main/ets/common/NotificationConfig';
import { NtfColorModeVM } from '../../../../main/ets/vm/NtfColorModeVM';
import { NotificationUtils } from '../../../../main/ets/common/NotificationUtils';
import { NtfSingleItemVM } from '../../../../main/ets/vm/NtfSingleItemVM';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/NotificationHeadsUp';
export default function Test() {
  describe('onItemHoverChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_setItemHover_and_updatePosition_when_isHover_is_true', 0, () => {
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let bannerFloatingController: BannerFloatingController = new BannerFloatingController();
      let notificationContentInTint: NotificationContentInTint = new NotificationContentInTint();
      let notificationContent: NotificationContent = new NotificationContent();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationUtils: NotificationUtils = new NotificationUtils();
      let ntfSingleItemVM: NtfSingleItemVM = new NtfSingleItemVM();
      let appProtectedVm: AppProtectedVm = new AppProtectedVm();
      let rootCard: RootCard = new RootCard();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = new LogHelper();
      let trace: Trace = new Trace();
      let rTLUtil: RTLUtil = new RTLUtil();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let sCBSceneSessionManager: SCBSceneSessionManager = new SCBSceneSessionManager();
      let baseStateMgr: baseStateMgr = new baseStateMgr();
      let cardScaleUtil: CardScaleUtil = new CardScaleUtil();
      let frameCount: FrameCount = new FrameCount();
      let immersiveBaseState: ImmersiveBaseState = new ImmersiveBaseState();
      let systemUICommonUtil: SystemUICommonUtil = new SystemUICommonUtil();
      let logDomain: LogDomain = new LogDomain();

      let mocker: MockKit = new MockKit();

      let mockCloseVM: NtfCloseVM = mocker.mockFunc(ntfCloseVM, ntfCloseVM.setItemHover);
      when(mockCloseVM)(ArgumentMatchers.any).afterReturn(null);

      let mockAppIconModifier: NtfAppIconModifier =
        mocker.mockFunc(ntfAppIconModifier, ntfAppIconModifier.updatePosition);
      when(mockAppIconModifier)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);


      let mockNtfSingleItemVM: NtfSingleItemVM = mocker.mockFunc(ntfSingleItemVM, ntfSingleItemVM.updateNtfEntry);
      when(mockNtfSingleItemVM)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

      let mockBaseStateMgr: baseStateMgr = mocker.mockFunc(baseStateMgr, baseStateMgr.getState);
      when(mockBaseStateMgr)([ArgumentMatchers.any]).afterReturn({
        type: StateType.INTERACTIVE
      });

      let mockCardScaleUtil: CardScaleUtil = mocker.mockFunc(cardScaleUtil, cardScaleUtil.getScale);
      when(mockCardScaleUtil)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(1.0);

      let mockFrameCount: FrameCount = mocker.mockFunc(frameCount, frameCount.get);
      when(mockFrameCount)([ArgumentMatchers.any]).afterReturn(1);

      let mockImmersiveBaseState: ImmersiveBaseState = mocker.mockFunc(immersiveBaseState, immersiveBaseState.update);
      when(mockImmersiveBaseState)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

      let mockSystemUICommonUtil: SystemUICommonUtil =
        mocker.mockFunc(systemUICommonUtil, systemUICommonUtil.getLiveUseScene);
      when(mockSystemUICommonUtil)([ArgumentMatchers.any]).afterReturn(LiveUseScene.VIDEO_CALL);


      ntfCloseVM.onItemHoverChange(true, ntfAppIconModifier, bannerFloatingController, notificationContentInTint,
        notificationContent, ntfTimeVM, notificationConfig, ntfColorModeVM, notificationUtils, ntfSingleItemVM,
        appProtectedVm, rootCard, commonUtils, logHelper, trace, rTLUtil, deviceHelper, sCBSceneSessionManager,
        baseStateMgr, cardScaleUtil, frameCount, immersiveBaseState, systemUICommonUtil, logDomain);

      mocker.ignoreMock(ntfCloseVM, ntfCloseVM.setItemHover);
      mocker.ignoreMock(ntfAppIconModifier, ntfAppIconModifier.updatePosition);
      mocker.ignoreMock(ntfSingleItemVM, ntfSingleItemVM.updateNtfEntry);
      mocker.ignoreMock(baseStateMgr, baseStateMgr.getState);
      mocker.ignoreMock(cardScaleUtil, cardScaleUtil.getScale);
      mocker.ignoreMock(frameCount, frameCount.get);
      mocker.ignoreMock(immersiveBaseState, immersiveBaseState.update);
      mocker.ignoreMock(systemUICommonUtil, systemUICommonUtil.getLiveUseScene);

    });

    it('should_call_cancelItemHover_when_isHover_is_false', 0, () => {
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let bannerFloatingController: BannerFloatingController = new BannerFloatingController();
      let notificationContentInTint: NotificationContentInTint = new NotificationContentInTint();
      let notificationContent: NotificationContent = new NotificationContent();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationUtils: NotificationUtils = new NotificationUtils();
      let ntfSingleItemVM: NtfSingleItemVM = new NtfSingleItemVM();
      let appProtectedVm: AppProtectedVm = new AppProtectedVm();
      let rootCard: RootCard = new RootCard();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = new LogHelper();
      let trace: Trace = new Trace();
      let rTLUtil: RTLUtil = new RTLUtil();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let sCBSceneSessionManager: SCBSceneSessionManager = new SCBSceneSessionManager();
      let baseStateMgr: baseStateMgr = new baseStateMgr();
      let cardScaleUtil: CardScaleUtil = new CardScaleUtil();
      let frameCount: FrameCount = new FrameCount();
      let immersiveBaseState: ImmersiveBaseState = new ImmersiveBaseState();
      let systemUICommonUtil: SystemUICommonUtil = new SystemUICommonUtil();
      let logDomain: LogDomain = new LogDomain();

      let mocker: MockKit = new MockKit();

      let mockCloseVM: NtfCloseVM = mocker.mockFunc(ntfCloseVM, ntfCloseVM.cancelItemHover);
      when(mockCloseVM)(ArgumentMatchers.any).afterReturn(null);

      let mockAppIconModifier: NtfAppIconModifier =
        mocker.mockFunc(ntfAppIconModifier, ntfAppIconModifier.updatePosition);
      when(mockAppIconModifier)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);


      let mockNtfSingleItemVM: NtfSingleItemVM = mocker.mockFunc(ntfSingleItemVM, ntfSingleItemVM.updateNtfEntry);
      when(mockNtfSingleItemVM)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

      let mockBaseStateMgr: baseStateMgr = mocker.mockFunc(baseStateMgr, baseStateMgr.getState);
      when(mockBaseStateMgr)([ArgumentMatchers.any]).afterReturn({
        type: StateType.INTERACTIVE
      });

      let mockCardScaleUtil: CardScaleUtil = mocker.mockFunc(cardScaleUtil, cardScaleUtil.getScale);
      when(mockCardScaleUtil)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(1.0);

      let mockFrameCount: FrameCount = mocker.mockFunc(frameCount, frameCount.get);
      when(mockFrameCount)([ArgumentMatchers.any]).afterReturn(1);

      let mockImmersiveBaseState: ImmersiveBaseState = mocker.mockFunc(immersiveBaseState, immersiveBaseState.update);
      when(mockImmersiveBaseState)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

    });

    it('should_call_setItemHover_and_updatePosition_when_isHover_is_true', 0, () => {
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let bannerFloatingController: BannerFloatingController = new BannerFloatingController();
      let notificationContentInTint: NotificationContentInTint = new NotificationContentInTint();
      let notificationContent: NotificationContent = new NotificationContent();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationUtils: NotificationUtils = new NotificationUtils();
      let ntfSingleItemVM: NtfSingleItemVM = new NtfSingleItemVM();
      let appProtectedVm: AppProtectedVm = new AppProtectedVm();
      let rootCard: RootCard = new RootCard();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = new LogHelper();
      let trace: Trace = new Trace();
      let rTLUtil: RTLUtil = new RTLUtil();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let sCBSceneSessionManager: SCBSceneSessionManager = new SCBSceneSessionManager();
      let baseStateMgr: baseStateMgr = new baseStateMgr();
      let cardScaleUtil: CardScaleUtil = new CardScaleUtil();
      let frameCount: FrameCount = new FrameCount();
      let immersiveBaseState: ImmersiveBaseState = new ImmersiveBaseState();
      let systemUICommonUtil: SystemUICommonUtil = new SystemUICommonUtil();
      let logDomain: LogDomain = new LogDomain();

      let mocker: MockKit = new MockKit();

      let mockCloseVM: NtfCloseVM = mocker.mockFunc(ntfCloseVM, ntfCloseVM.setItemHover);
      when(mockCloseVM)(ArgumentMatchers.any).afterReturn(null);

      let mockAppIconModifier: NtfAppIconModifier =
        mocker.mockFunc(ntfAppIconModifier, ntfAppIconModifier.updatePosition);
      when(mockAppIconModifier)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);


      let mockNtfSingleItemVM: NtfSingleItemVM = mocker.mockFunc(ntfSingleItemVM, ntfSingleItemVM.updateNtfEntry);
      when(mockNtfSingleItemVM)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

      let mockBaseStateMgr: baseStateMgr = mocker.mockFunc(baseStateMgr, baseStateMgr.getState);
      when(mockBaseStateMgr)([ArgumentMatchers.any]).afterReturn({
        type: StateType.INTERACTIVE
      });

      let mockCardScaleUtil: CardScaleUtil = mocker.mockFunc(cardScaleUtil, cardScaleUtil.getScale);
      when(mockCardScaleUtil)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(1.0);

      let mockFrameCount: FrameCount = mocker.mockFunc(frameCount, frameCount.get);
      when(mockFrameCount)([ArgumentMatchers.any]).afterReturn(1);

      let mockImmersiveBaseState: ImmersiveBaseState = mocker.mockFunc(immersiveBaseState, immersiveBaseState.update);
      when(mockImmersiveBaseState)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

      let mockSystemUICommonUtil: SystemUICommonUtil =
        mocker.mockFunc(systemUICommonUtil, systemUICommonUtil.getLiveUseScene);
      when(mockSystemUICommonUtil)([ArgumentMatchers.any]).afterReturn(LiveUseScene.VIDEO_CALL);


      ntfCloseVM.onItemHoverChange(true, ntfAppIconModifier, bannerFloatingController, notificationContentInTint,
        notificationContent, ntfTimeVM, notificationConfig, ntfColorModeVM, notificationUtils, ntfSingleItemVM,
        appProtectedVm, rootCard, commonUtils, logHelper, trace, rTLUtil, deviceHelper, sCBSceneSessionManager,
        baseStateMgr, cardScaleUtil, frameCount, immersiveBaseState, systemUICommonUtil, logDomain);

      mocker.ignoreMock(ntfCloseVM, ntfCloseVM.setItemHover);
      mocker.ignoreMock(ntfAppIconModifier, ntfAppIconModifier.updatePosition);
      mocker.ignoreMock(ntfSingleItemVM, ntfSingleItemVM.updateNtfEntry);
      mocker.ignoreMock(baseStateMgr, baseStateMgr.getState);
      mocker.ignoreMock(cardScaleUtil, cardScaleUtil.getScale);
      mocker.ignoreMock(frameCount, frameCount.get);
      mocker.ignoreMock(immersiveBaseState, immersiveBaseState.update);
      mocker.ignoreMock(systemUICommonUtil, systemUICommonUtil.getLiveUseScene);

    });

    it('should_call_cancelItemHover_when_isHover_is_false', 0, () => {
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let bannerFloatingController: BannerFloatingController = new BannerFloatingController();
      let notificationContentInTint: NotificationContentInTint = new NotificationContentInTint();
      let notificationContent: NotificationContent = new NotificationContent();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationUtils: NotificationUtils = new NotificationUtils();
      let ntfSingleItemVM: NtfSingleItemVM = new NtfSingleItemVM();
      let appProtectedVm: AppProtectedVm = new AppProtectedVm();
      let rootCard: RootCard = new RootCard();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = new LogHelper();
      let trace: Trace = new Trace();
      let rTLUtil: RTLUtil = new RTLUtil();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let sCBSceneSessionManager: SCBSceneSessionManager = new SCBSceneSessionManager();
      let baseStateMgr: baseStateMgr = new baseStateMgr();
      let cardScaleUtil: CardScaleUtil = new CardScaleUtil();
      let frameCount: FrameCount = new FrameCount();
      let immersiveBaseState: ImmersiveBaseState = new ImmersiveBaseState();
      let systemUICommonUtil: SystemUICommonUtil = new SystemUICommonUtil();
      let logDomain: LogDomain = new LogDomain();

      let mocker: MockKit = new MockKit();

      let mockCloseVM: NtfCloseVM = mocker.mockFunc(ntfCloseVM, ntfCloseVM.cancelItemHover);
      when(mockCloseVM)(ArgumentMatchers.any).afterReturn(null);

      let mockAppIconModifier: NtfAppIconModifier =
        mocker.mockFunc(ntfAppIconModifier, ntfAppIconModifier.updatePosition);
      when(mockAppIconModifier)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);


      let mockNtfSingleItemVM: NtfSingleItemVM = mocker.mockFunc(ntfSingleItemVM, ntfSingleItemVM.updateNtfEntry);
      when(mockNtfSingleItemVM)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

      let mockBaseStateMgr: baseStateMgr = mocker.mockFunc(baseStateMgr, baseStateMgr.getState);
      when(mockBaseStateMgr)([ArgumentMatchers.any]).afterReturn({
        type: StateType.INTERACTIVE
      });

      let mockCardScaleUtil: CardScaleUtil = mocker.mockFunc(cardScaleUtil, cardScaleUtil.getScale);
      when(mockCardScaleUtil)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(1.0);

      let mockFrameCount: FrameCount = mocker.mockFunc(frameCount, frameCount.get);
      when(mockFrameCount)([ArgumentMatchers.any]).afterReturn(1);

      let mockImmersiveBaseState: ImmersiveBaseState = mocker.mockFunc(immersiveBaseState, immersiveBaseState.update);
      when(mockImmersiveBaseState)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);
    });
    it('should_call_setItemHover_and_updatePosition_when_isHover_is_true', 0, () => {
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let bannerFloatingController: BannerFloatingController = new BannerFloatingController();
      let notificationContentInTint: NotificationContentInTint = new NotificationContentInTint();
      let notificationContent: NotificationContent = new NotificationContent();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationUtils: NotificationUtils = new NotificationUtils();
      let ntfSingleItemVM: NtfSingleItemVM = new NtfSingleItemVM();
      let appProtectedVm: AppProtectedVm = new AppProtectedVm();
      let rootCard: RootCard = new RootCard();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = new LogHelper();
      let trace: Trace = new Trace();
      let rTLUtil: RTLUtil = new RTLUtil();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let sCBSceneSessionManager: SCBSceneSessionManager = new SCBSceneSessionManager();
      let baseStateMgr: baseStateMgr = new baseStateMgr();
      let cardScaleUtil: CardScaleUtil = new CardScaleUtil();
      let frameCount: FrameCount = new FrameCount();
      let immersiveBaseState: ImmersiveBaseState = new ImmersiveBaseState();
      let systemUICommonUtil: SystemUICommonUtil = new SystemUICommonUtil();
      let logDomain: LogDomain = new LogDomain();

      let mocker: MockKit = new MockKit();

      let mockCloseVM: NtfCloseVM = mocker.mockFunc(ntfCloseVM, ntfCloseVM.setItemHover);
      when(mockCloseVM)(ArgumentMatchers.any).afterReturn(null);

      let mockAppIconModifier: NtfAppIconModifier =
        mocker.mockFunc(ntfAppIconModifier, ntfAppIconModifier.updatePosition);
      when(mockAppIconModifier)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);


      let mockNtfSingleItemVM: NtfSingleItemVM = mocker.mockFunc(ntfSingleItemVM, ntfSingleItemVM.updateNtfEntry);
      when(mockNtfSingleItemVM)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

      let mockBaseStateMgr: baseStateMgr = mocker.mockFunc(baseStateMgr, baseStateMgr.getState);
      when(mockBaseStateMgr)([ArgumentMatchers.any]).afterReturn({
        type: StateType.INTERACTIVE
      });

      let mockCardScaleUtil: CardScaleUtil = mocker.mockFunc(cardScaleUtil, cardScaleUtil.getScale);
      when(mockCardScaleUtil)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(1.0);

      let mockFrameCount: FrameCount = mocker.mockFunc(frameCount, frameCount.get);
      when(mockFrameCount)([ArgumentMatchers.any]).afterReturn(1);

      let mockImmersiveBaseState: ImmersiveBaseState = mocker.mockFunc(immersiveBaseState, immersiveBaseState.update);
      when(mockImmersiveBaseState)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

      let mockSystemUICommonUtil: SystemUICommonUtil =
        mocker.mockFunc(systemUICommonUtil, systemUICommonUtil.getLiveUseScene);
      when(mockSystemUICommonUtil)([ArgumentMatchers.any]).afterReturn(LiveUseScene.VIDEO_CALL);


      ntfCloseVM.onItemHoverChange(true, ntfAppIconModifier, bannerFloatingController, notificationContentInTint,
        notificationContent, ntfTimeVM, notificationConfig, ntfColorModeVM, notificationUtils, ntfSingleItemVM,
        appProtectedVm, rootCard, commonUtils, logHelper, trace, rTLUtil, deviceHelper, sCBSceneSessionManager,
        baseStateMgr, cardScaleUtil, frameCount, immersiveBaseState, systemUICommonUtil, logDomain);

      mocker.ignoreMock(ntfCloseVM, ntfCloseVM.setItemHover);
      mocker.ignoreMock(ntfAppIconModifier, ntfAppIconModifier.updatePosition);
      mocker.ignoreMock(ntfSingleItemVM, ntfSingleItemVM.updateNtfEntry);
      mocker.ignoreMock(baseStateMgr, baseStateMgr.getState);
      mocker.ignoreMock(cardScaleUtil, cardScaleUtil.getScale);
      mocker.ignoreMock(frameCount, frameCount.get);
      mocker.ignoreMock(immersiveBaseState, immersiveBaseState.update);
      mocker.ignoreMock(systemUICommonUtil, systemUICommonUtil.getLiveUseScene);
    });

    it('should_call_cancelItemHover_when_isHover_is_false', 0, () => {
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let bannerFloatingController: BannerFloatingController = new BannerFloatingController();
      let notificationContentInTint: NotificationContentInTint = new NotificationContentInTint();
      let notificationContent: NotificationContent = new NotificationContent();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationUtils: NotificationUtils = new NotificationUtils();
      let ntfSingleItemVM: NtfSingleItemVM = new NtfSingleItemVM();
      let appProtectedVm: AppProtectedVm = new AppProtectedVm();
      let rootCard: RootCard = new RootCard();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = new LogHelper();
      let trace: Trace = new Trace();
      let rTLUtil: RTLUtil = new RTLUtil();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let sCBSceneSessionManager: SCBSceneSessionManager = new SCBSceneSessionManager();
      let baseStateMgr: baseStateMgr = new baseStateMgr();
      let cardScaleUtil: CardScaleUtil = new CardScaleUtil();
      let frameCount: FrameCount = new FrameCount();
      let immersiveBaseState: ImmersiveBaseState = new ImmersiveBaseState();
      let systemUICommonUtil: SystemUICommonUtil = new SystemUICommonUtil();
      let logDomain: LogDomain = new LogDomain();

      let mocker: MockKit = new MockKit();

      let mockCloseVM: NtfCloseVM = mocker.mockFunc(ntfCloseVM, ntfCloseVM.cancelItemHover);
      when(mockCloseVM)(ArgumentMatchers.any).afterReturn(null);

      let mockAppIconModifier: NtfAppIconModifier =
        mocker.mockFunc(ntfAppIconModifier, ntfAppIconModifier.updatePosition);
      when(mockAppIconModifier)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);


      let mockNtfSingleItemVM: NtfSingleItemVM = mocker.mockFunc(ntfSingleItemVM, ntfSingleItemVM.updateNtfEntry);
      when(mockNtfSingleItemVM)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

      let mockBaseStateMgr: baseStateMgr = mocker.mockFunc(baseStateMgr, baseStateMgr.getState);
      when(mockBaseStateMgr)([ArgumentMatchers.any]).afterReturn({
        type: StateType.INTERACTIVE
      });

      let mockCardScaleUtil: CardScaleUtil = mocker.mockFunc(cardScaleUtil, cardScaleUtil.getScale);
      when(mockCardScaleUtil)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(1.0);

      let mockFrameCount: FrameCount = mocker.mockFunc(frameCount, frameCount.get);
      when(mockFrameCount)([ArgumentMatchers.any]).afterReturn(1);

      let mockImmersiveBaseState: ImmersiveBaseState = mocker.mockFunc(immersiveBaseState, immersiveBaseState.update);
      when(mockImmersiveBaseState)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);
    });

    it('should_call_setItemHover_and_updatePosition_when_isHover_is_true', 0, () => {
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let bannerFloatingController: BannerFloatingController = new BannerFloatingController();
      let notificationContentInTint: NotificationContentInTint = new NotificationContentInTint();
      let notificationContent: NotificationContent = new NotificationContent();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationUtils: NotificationUtils = new NotificationUtils();
      let ntfSingleItemVM: NtfSingleItemVM = new NtfSingleItemVM();
      let appProtectedVm: AppProtectedVm = new AppProtectedVm();
      let rootCard: RootCard = new RootCard();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = new LogHelper();
      let trace: Trace = new Trace();
      let rTLUtil: RTLUtil = new RTLUtil();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let sCBSceneSessionManager: SCBSceneSessionManager = new SCBSceneSessionManager();
      let baseStateMgr: baseStateMgr = new baseStateMgr();
      let cardScaleUtil: CardScaleUtil = new CardScaleUtil();
      let frameCount: FrameCount = new FrameCount();
      let immersiveBaseState: ImmersiveBaseState = new ImmersiveBaseState();
      let systemUICommonUtil: SystemUICommonUtil = new SystemUICommonUtil();
      let logDomain: LogDomain = new LogDomain();

      let mocker: MockKit = new MockKit();

      let mockCloseVM: NtfCloseVM = mocker.mockFunc(ntfCloseVM, ntfCloseVM.setItemHover);
      when(mockCloseVM)(ArgumentMatchers.any).afterReturn(null);

      let mockAppIconModifier: NtfAppIconModifier = mocker.mockFunc(ntfAppIconModifier, ntfAppIconModifier.updatePosition);
      when(mockAppIconModifier)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);


      let mockNtfSingleItemVM: NtfSingleItemVM = mocker.mockFunc(ntfSingleItemVM, ntfSingleItemVM.updateNtfEntry);
      when(mockNtfSingleItemVM)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

      let mockBaseStateMgr: baseStateMgr = mocker.mockFunc(baseStateMgr, baseStateMgr.getState);
      when(mockBaseStateMgr)([ArgumentMatchers.any]).afterReturn({ type: StateType.INTERACTIVE });

      let mockCardScaleUtil: CardScaleUtil = mocker.mockFunc(cardScaleUtil, cardScaleUtil.getScale);
      when(mockCardScaleUtil)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(1.0);

      let mockFrameCount: FrameCount = mocker.mockFunc(frameCount, frameCount.get);
      when(mockFrameCount)([ArgumentMatchers.any]).afterReturn(1);

      let mockImmersiveBaseState: ImmersiveBaseState = mocker.mockFunc(immersiveBaseState, immersiveBaseState.update);
      when(mockImmersiveBaseState)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

      let mockSystemUICommonUtil: SystemUICommonUtil = mocker.mockFunc(systemUICommonUtil, systemUICommonUtil.getLiveUseScene);
      when(mockSystemUICommonUtil)([ArgumentMatchers.any]).afterReturn(LiveUseScene.VIDEO_CALL);


      ntfCloseVM.onItemHoverChange(true, ntfAppIconModifier, bannerFloatingController, notificationContentInTint, notificationContent, ntfTimeVM, notificationConfig, ntfColorModeVM, notificationUtils, ntfSingleItemVM, appProtectedVm, rootCard, commonUtils, logHelper, trace, rTLUtil, deviceHelper, sCBSceneSessionManager, baseStateMgr, cardScaleUtil, frameCount, immersiveBaseState, systemUICommonUtil, logDomain);

      mocker.ignoreMock(ntfCloseVM, ntfCloseVM.setItemHover);
      mocker.ignoreMock(ntfAppIconModifier, ntfAppIconModifier.updatePosition);
      mocker.ignoreMock(ntfSingleItemVM, ntfSingleItemVM.updateNtfEntry);
      mocker.ignoreMock(baseStateMgr, baseStateMgr.getState);
      mocker.ignoreMock(cardScaleUtil, cardScaleUtil.getScale);
      mocker.ignoreMock(frameCount, frameCount.get);
      mocker.ignoreMock(immersiveBaseState, immersiveBaseState.update);
      mocker.ignoreMock(systemUICommonUtil, systemUICommonUtil.getLiveUseScene);
    });

  })

}