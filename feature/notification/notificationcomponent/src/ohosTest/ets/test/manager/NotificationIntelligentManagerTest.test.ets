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
import {
  NotificationIntelligentManager,
  NotificationConstants,
  FaceUnlockConstants,
  EventManager,
  CommonEventManager,
  sSettingsUtil,
  systemparameter,
  notificationCcmConfig,
  SwingTrackVm,
  hideBannerNtfContentObj,
  screenLockStateManager,
  osAccount,
  FingerprintUtil,
  ClickNotificationMaintenance,
  ClickNotificationErrorCode,
  ClickRegion,
  BaseInfo,
  SMART_REMINDER_SWITCH,
  SettingsKeyConstants,
  FaceSwitchEnableEvent,
  HiddenBannerNtfEnableEvent,
  FingerprintUnlockSwitchEnableEvent,
  USER_CREDENTIAL_UPDATED_EVENT,
  log,
  LogWithHa,
  CheckEmptyUtils
} from './NotificationIntelligentManager';

export default function NotificationIntelligentManagerTest() {
  describe('NotificationIntelligentManager', () => {
    let notificationManager: NotificationIntelligentManager;
    let mockEventManager: jest.Mocked<EventManager>;
    let mockCommonEventManager: jest.Mocked<CommonEventManager>;
    let mockSystemParameter: jest.Mocked<typeof systemparameter>;
    let mockNotificationCcmConfig: jest.Mocked<typeof notificationCcmConfig>;
    let mockSwingTrackVm: jest.Mocked<SwingTrackVm>;
    let mockHideBannerNtfContentObj: jest.Mocked<typeof hideBannerNtfContentObj>;
    let mockScreenLockStateManager: jest.Mocked<typeof screenLockStateManager>;
    let mockOsAccount: jest.Mocked<typeof osAccount>;
    let mockFingerprintUtil: jest.Mocked<typeof FingerprintUtil>;
    let mockClickNotificationMaintenance: jest.Mocked<ClickNotificationMaintenance>;
    let mockLog: jest.Mocked<typeof log>;
    let mockLogWithHa: jest.Mocked<typeof LogWithHa>;
    let mockCheckEmptyUtils: jest.Mocked<typeof CheckEmptyUtils>;

    beforeEach(() => {
      // 初始化所有依赖
      mockEventManager = {
        on: jest.fn(),
        off: jest.fn()
      };
      mockCommonEventManager = {
        createSubscriber: jest.fn(),
        subscribe: jest.fn(),
        unsubscribe: jest.fn()
      };
      mockSystemParameter = {
        getSync: jest.fn()
      };
      mockNotificationCcmConfig = {
        initFinished: jest.fn()
      };
      mockSwingTrackVm = {
        init: jest.fn(),
        register: jest.fn(),
        unRegister: jest.fn()
      };
      mockHideBannerNtfContentObj = {
        updateSupportSwing: jest.fn(),
        updateFaceOpen: jest.fn(),
        updateHiddenContent: jest.fn(),
        updateFaceData: jest.fn(),
        isUseSwing: jest.fn(),
        getRegisterSwing: jest.fn(),
        getSupportSwing: jest.fn(),
        getFaceOpen: jest.fn(),
        getHiddenContent: jest.fn()
      };
      mockScreenLockStateManager = {
        registerScreenLockState: jest.fn()
      };
      mockOsAccount = {
        UserIdentityManager: jest.fn(() => ({
          getAuthInfo: jest.fn()
        }))
      };
      mockFingerprintUtil = {
        isLowFingerPrint: jest.fn()
      };
      mockClickNotificationMaintenance = {
        reportClick: jest.fn()
      };
      mockLog = {
        showInfo: jest.fn(),
        showError: jest.fn()
      };
      mockLogWithHa = {
        error: jest.fn()
      };
      mockCheckEmptyUtils = {
        isEmpty: jest.fn()
      };

      notificationManager = new NotificationIntelligentManager();
    });

    describe('init', () => {
      it('should initialize the manager correctly', async () => {
        // 模拟依赖行为
        mockSystemParameter.getSync.mockReturnValue(true);
        mockCommonEventManager.createSubscriber.mockResolvedValue({
          subscribe: jest.fn(),
          unsubscribe: jest.fn()
        });
        mockNotificationCcmConfig.initFinished.mockResolvedValue(undefined);
        mockSwingTrackVm.init.mockResolvedValue(undefined);

        await notificationManager.init();

        // 验证初始化方法是否正确调用
        expect(mockEventManager.on).toHaveBeenCalled();
        expect(mockCommonEventManager.createSubscriber).toHaveBeenCalled();
        expect(mockNotificationCcmConfig.initFinished).toHaveBeenCalled();
        expect(mockSwingTrackVm.init).toHaveBeenCalled();
        expect(notificationManager.isInit).toBe(true);
      });

      it('should not reinitialize if already initialized', async () => {
        notificationManager.isInit = true;
        await notificationManager.init();
        expect(mockEventManager.on).not.toHaveBeenCalled();
      });
    });

    describe('deinit', () => {
      it('should deinitialize the manager correctly', () => {
        notificationManager.deinit();
        expect(mockCommonEventManager.unsubscribe).toHaveBeenCalled();
        expect(notificationManager.isInit).toBe(false);
      });
    });

    describe('initSwingEnableData', () => {
      it('should initialize swing enable data correctly', async () => {
        mockSystemParameter.getSync.mockReturnValue(true);
        mockCommonEventManager.createSubscriber.mockResolvedValue({
          subscribe: jest.fn(),
          unsubscribe: jest.fn()
        });
        mockNotificationCcmConfig.initFinished.mockResolvedValue(undefined);
        mockSwingTrackVm.init.mockResolvedValue(undefined);

        await notificationManager.initSwingEnableData();

        expect(mockHideBannerNtfContentObj.updateSupportSwing).toHaveBeenCalled();
        expect(mockHideBannerNtfContentObj.updateFaceOpen).toHaveBeenCalled();
        expect(mockHideBannerNtfContentObj.updateHiddenContent).toHaveBeenCalled();
        expect(mockSwingTrackVm.init).toHaveBeenCalled();
      });

      it('should handle errors during initialization', async () => {
        const mockError = new Error('Test error');
        mockSystemParameter.getSync.mockImplementation(() => {
          throw mockError;
        });

        await notificationManager.initSwingEnableData();

        expect(mockLogWithHa.error).toHaveBeenCalled();
      });
    });

    describe('subscribeFaceDataChanged', () => {
      it('should subscribe face data changed events correctly', () => {
        notificationManager.subscribeFaceDataChanged();
        expect(mockCommonEventManager.createSubscriber).toHaveBeenCalled();
        expect(mockCommonEventManager.subscribe).toHaveBeenCalled();
      });

      it('should handle subscription errors', () => {
        const mockError = new Error('Test error');
        mockCommonEventManager.subscribe.mockImplementation((subscriber, callback) => {
          callback(mockError, null);
        });

        notificationManager.subscribeFaceDataChanged();
        expect(mockLog.error).toHaveBeenCalled();
      });
    });

    describe('updateFaceDataConfig', () => {
      it('should update face data config when face data exists', () => {
        const mockEventData = {
          event: USER_CREDENTIAL_UPDATED_EVENT,
          parameters: {
            credentialCount: '1'
          }
        };
        notificationManager.updateFaceDataConfig(null, mockEventData);
        expect(mockHideBannerNtfContentObj.updateFaceData).toHaveBeenCalledWith(true);
        expect(mockSwingTrackVm.register).toHaveBeenCalled();
      });

      it('should update face data config when face data does not exist', () => {
        const mockEventData = {
          event: USER_CREDENTIAL_UPDATED_EVENT,
          parameters: {
            credentialCount: '0'
          }
        };
        notificationManager.updateFaceDataConfig(null, mockEventData);
        expect(mockHideBannerNtfContentObj.updateFaceData).toHaveBeenCalledWith(false);
        expect(mockSwingTrackVm.unRegister).toHaveBeenCalled();
      });

      it('should handle invalid events', () => {
        const mockEventData = {
          event: 'INVALID_EVENT',
          parameters: {}
        };
        notificationManager.updateFaceDataConfig(null, mockEventData);
        expect(mockLog.showInfo).toHaveBeenCalled();
      });
    });

    describe('unsubscribeCommonEventSubscriber', () => {
      it('should unsubscribe the face change subscriber', () => {
        const mockSubscriber = {
          unsubscribe: jest.fn()
        };
        notificationManager.unsubscribeCommonEventSubscriber(mockSubscriber);
        expect(mockSubscriber.unsubscribe).toHaveBeenCalled();
      });

      it('should handle unsubscribe errors', () => {
        const mockSubscriber = {
          unsubscribe: jest.fn(() => {
            throw new Error('Test error');
          })
        };
        notificationManager.unsubscribeCommonEventSubscriber(mockSubscriber);
        expect(mockLog.showError).toHaveBeenCalled();
      });
    });

    describe('screenLockStateListener', () => {
      it('should handle lock screen event', async () => {
        mockHideBannerNtfContentObj.getRegisterSwing.mockReturnValue(true);
        notificationManager.screenLockStateListener.onEnterHost();
        expect(mockSwingTrackVm.unRegister).toHaveBeenCalled();
      });

      it('should handle unlock screen event', async () => {
        mockHideBannerNtfContentObj.getRegisterSwing.mockReturnValue(false);
        mockHideBannerNtfContentObj.isUseSwing.mockReturnValue(true);
        await notificationManager.screenLockStateListener.onExitKeyguard();
        expect(mockSwingTrackVm.register).toHaveBeenCalled();
      });
    });

    describe('initHideBannerContent', () => {
      it('should initialize hide banner content correctly', async () => {
        mockHideBannerNtfContentObj.getSupportSwing.mockReturnValue(true);
        mockOsAccount.UserIdentityManager().getAuthInfo.mockResolvedValue([{}]);
        const result = await notificationManager.initHideBannerContent();
        expect(result).toBe(true);
        expect(mockHideBannerNtfContentObj.updateFaceData).toHaveBeenCalled();
      });

      it('should handle errors during initialization', async () => {
        mockHideBannerNtfContentObj.getSupportSwing.mockReturnValue(true);
        mockOsAccount.UserIdentityManager().getAuthInfo.mockRejectedValue(new Error('Test error'));
        const result = await notificationManager.initHideBannerContent();
        expect(result).toBe(false);
        expect(mockLog.showError).toHaveBeenCalled();
      });
    });

    describe('onFaceSwitchEnableEvent', () => {
      it('should handle face switch enable event', () => {
        const mockEvent = {
          isFaceSwitchEnable: () => true
        };
        notificationManager.onFaceSwitchEnableEvent(mockEvent as FaceSwitchEnableEvent);
        expect(mockHideBannerNtfContentObj.updateFaceOpen).toHaveBeenCalledWith(1);
        expect(mockSwingTrackVm.register).toHaveBeenCalled();
      });

      it('should handle face switch disable event', () => {
        const mockEvent = {
          isFaceSwitchEnable: () => false
        };
        notificationManager.onFaceSwitchEnableEvent(mockEvent as FaceSwitchEnableEvent);
        expect(mockHideBannerNtfContentObj.updateFaceOpen).toHaveBeenCalledWith(0);
        expect(mockSwingTrackVm.unRegister).toHaveBeenCalled();
      });
    });

    describe('isFaceEnrolled', () => {
      it('should check if face data is enrolled', async () => {
        mockOsAccount.UserIdentityManager().getAuthInfo.mockResolvedValue([{}]);
        const result = await notificationManager.isFaceEnrolled();
        expect(result).toBe(true);
      });

      it('should handle no enrolled face data', async () => {
        mockOsAccount.UserIdentityManager().getAuthInfo.mockResolvedValue([]);
        const result = await notificationManager.isFaceEnrolled();
        expect(result).toBe(false);
      });
    });

    describe('onFingerprintUnlockSwitchEnableEvent', () => {
      it('should handle fingerprint unlock enable event', async () => {
        const mockEvent = {
          isFingerprintUnlockSwitchEnable: () => true
        };
        mockFingerprintUtil.isLowFingerPrint.mockReturnValue(true);
        await notificationManager.onFingerprintUnlockSwitchEnableEvent(mockEvent as FingerprintUnlockSwitchEnableEvent);
        expect(sSettingsUtil.setSecureValue).toHaveBeenCalled();
      });

      it('should handle fingerprint unlock disable event', async () => {
        const mockEvent = {
          isFingerprintUnlockSwitchEnable: () => false
        };
        await notificationManager.onFingerprintUnlockSwitchEnableEvent(mockEvent as FingerprintUnlockSwitchEnableEvent);
        expect(sSettingsUtil.setSecureValue).not.toHaveBeenCalled();
      });
    });

    describe('onHiddenBannerNtfEnableEvent', () => {
      it('should handle hidden banner notification enable event', () => {
        const mockEvent = {
          isHiddenBannerNtfEnable: () => true
        };
        notificationManager.onHiddenBannerNtfEnableEvent(mockEvent as HiddenBannerNtfEnableEvent);
        expect(mockHideBannerNtfContentObj.updateHiddenContent).toHaveBeenCalledWith(1);
        expect(mockSwingTrackVm.register).toHaveBeenCalled();
      });

      it('should handle hidden banner notification disable event', () => {
        const mockEvent = {
          isHiddenBannerNtfEnable: () => false
        };
        notificationManager.onHiddenBannerNtfEnableEvent(mockEvent as HiddenBannerNtfEnableEvent);
        expect(mockHideBannerNtfContentObj.updateHiddenContent).toHaveBeenCalledWith(0);
        expect(mockSwingTrackVm.unRegister).toHaveBeenCalled();
      });
    });
  });
}