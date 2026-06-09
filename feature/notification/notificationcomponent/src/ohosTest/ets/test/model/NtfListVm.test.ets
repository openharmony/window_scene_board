import { afterEach, beforeEach, describe, expect, it } from "@ohos/hypium";
import { BaseNotification } from "@ohos/systemuicommon/src/main/ets/model/BaseNotification";
import { DisplayMgr } from "@ohos/windowscene";
import { NotificationListAdapter } from "../../../../main/ets/model/NotificationListAdapter";
import { NtfListVm } from "../../../../main/ets/model/NtfListVm";

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
export default function NtfListVmTest() {

  describe('NtfListVm_init', () => {

    let ntfListVm: NtfListVm;
    let mockCallback: MockCallback;
    let mockEventMgr: MockEventManager;
    let mockNtfAdapter: MockNtfAdapter;
    let mockListContentConfig: MockListContentConfig;

    beforeEach(() => {

      mockCallback = new MockCallback();
      mockEventMgr = new MockEventManager();
      mockNtfAdapter = new MockNtfAdapter();
      mockListContentConfig = new MockListContentConfig();

      // 模拟依赖注入（根据实际代码调整）
      ntfListVm = new NtfListVm();
      ntfListVm.eventMgr = mockEventMgr;
      ntfListVm.ntfAdapter = mockNtfAdapter;
      ntfListVm.listContentConfig = mockListContentConfig;
    });

    describe('init_method', () => {

      it('test_init_sets_screen_height_on_orientation_change', 0, async () => {
        // Arrange
        const mockDisplay = { height: 2000 };
        jest.spyOn(DisplayMgr, 'getCurrentDisplay').mockResolvedValue(mockDisplay);

        // Act
        await ntfListVm.init(mockCallback);

        // Assert
        expect(ntfListVm.screenHeight).assertEqual(2000);
      });

      it('test_init_registers_notification_entry_event_listener', 0, () => {
        // Act
        ntfListVm.init(mockCallback);

        // Assert
        expect(mockEventMgr.on).toHaveBeenCalledWith(BaseNotificationEvent, ntfListVm.onBaseNotificationEvent);
      });

      it('test_init_registers_window_event_listener_for_keyguard_visibility', 0, () => {
        // Act
        ntfListVm.init(mockCallback);

        // Assert
        expect(mockEventMgr.on).toHaveBeenCalledWith(WindowEvent, ntfListVm.onWindowEvent);
      });

      it('test_init_registers_display_event_listener_when_dropdown_or_keyguard', 0, () => {
        // Arrange
        jest.spyOn(ntfListVm, 'isDropdown').mockReturnValue(true);

        // Act
        ntfListVm.init(mockCallback);

        // Assert
        expect(mockEventMgr.on).toHaveBeenCalledWith(DisplayEvent, ntfListVm.onDisplayEvent);
      });

      it('test_init_does_not_register_display_event_listener_when_neither_dropdown_nor_keyguard', 0, () => {
        // Arrange
        jest.spyOn(ntfListVm, 'isDropdown').mockReturnValue(false);
        jest.spyOn(ntfListVm, 'isKeyguard').mockReturnValue(false);

        // Act
        ntfListVm.init(mockCallback);

        // Assert
        expect(mockEventMgr.on).not.toHaveBeenCalledWith(DisplayEvent, ntfListVm.onDisplayEvent);
      });

      it('test_init_enables_freeze_view_for_dropdown', 0, () => {
        // Arrange
        jest.spyOn(ntfListVm, 'isDropdown').mockReturnValue(true);

        // Act
        ntfListVm.init(mockCallback);

        // Assert
        expect(mockNtfAdapter.setFreezeViewEnable).toHaveBeenCalledWith(true);
      });

      it('test_init_registers_ntf_unread_event_for_pc', 0, () => {
        // Arrange
        jest.spyOn(ntfListVm, 'isPc').mockReturnValue(true);

        // Act
        ntfListVm.init(mockCallback);

        // Assert
        expect(mockEventMgr.produceOn).toHaveBeenCalledWith(NtfUnreadEvent, ntfListVm.onProduceNtfUnreadEvent);
      });

      it('test_init_subscribes_config_changes', 0, () => {
        // Act
        ntfListVm.init(mockCallback);

        // Assert
        expect(notificationConfigManager.subscribeChangeEvent)
          .toHaveBeenCalledWith(ntfListVm.onNotificationConfigChange);
      });

      it('test_init_registers_heads_up_change_event_listener', 0, () => {
        // Act
        ntfListVm.init(mockCallback);

        // Assert
        expect(mockEventMgr.on).toHaveBeenCalledWith(
          HeadsUpChangeEvent,
          ntfListVm.onHeadsUpChangeEvent.bind(ntfListVm)
        );
      });

      it('test_init_adds_filter_listener_when_outer_home', 0, () => {
        // Arrange
        const isOuterHome = true;
        jest.spyOn(global, 'isOuterHome').mockReturnValue(isOuterHome);

        // Act
        ntfListVm.init(mockCallback);

        // Assert
        expect(mockListContentConfig.isFilterNtfAfterScreenLockChangeSet.add)
          .toHaveBeenCalledWith(ntfListVm.onIsFilterNtfAfterScreenLockChange);
      });

      it('test_init_does_not_add_filter_listener_when_not_outer_home', 0, () => {
        // Arrange
        const isOuterHome = false;
        jest.spyOn(global, 'isOuterHome').mockReturnValue(isOuterHome);

        // Act
        ntfListVm.init(mockCallback);

        // Assert
        expect(mockListContentConfig.isFilterNtfAfterScreenLockChangeSet.add).not.toHaveBeenCalled();
      });
    });
  });

    describe('getNtfAdapterList', () => {
      it('returns an empty array when the internal list is empty', 0, () => {
        const service = new NotificationService();
        expect(service.getNtfAdapterList()).toEqual([]);
      });

      it('returns the correct array when elements are present', 0, () => {
        const entries: BaseNotification[] = [
          new BaseNotification(),
          new BaseNotification(),
        ];
        const service = new NotificationService(entries);
        expect(service.getNtfAdapterList()).assertEqual(entries);
      });

      it('returns the same reference as the internal list', 0, () => {
        const entries: BaseNotification[] = [new BaseNotification()];
        const service = new NotificationService(entries);
        expect(service.getNtfAdapterList()).assertEqual(entries);
      });

      it('reflects changes to the internal list', 0, () => {
        const service = new NotificationService();
        const newEntry = new BaseNotification();
        (service as any).ntfAdapterList.push(newEntry); // 强制类型转换访问私有属性
        expect(service.getNtfAdapterList()).assertContain(newEntry);
      });
    });

  describe('NotificationService.onDestroy', () => {
    let service: NotificationService;
    let mockEventMgr: any;
    let mockCallback: any;

    beforeEach(() => {
      mockEventMgr = { offAll: jest.fn() };
      mockCallback = jest.fn();
      service = new NotificationService();
      service.eventMgr = mockEventMgr;
      service.callback = mockCallback;
      service.unsubscribeDropdown = jest.fn();
      service.ntfAdapterList = [/* 模拟数据 */];
      jest.spyOn(log, 'showInfo').mockImplementation(() => {});
      jest.spyOn(notificationConfigManager, 'unsubscribeChangeEvent').mockImplementation(() => {});
      jest.spyOn(SCBScreenSessionManager.getInstance(), 'unRegisterScreenPropertyChangeCallbacks')
        .mockImplementation(() => {
        });
      jest.spyOn(sEventManager, 'off').mockImplementation(() => {
      });
      jest.spyOn(DropdownController, 'getInstance').mockReturnValue({
        getId: () => 'dropdown-id'
      });
      jest.spyOn(global, 'isOuterHome').mockImplementation(() => false); // 默认值
    });

    afterEach(() => {
      jest.clearAllMocks();
    });

    describe('when callback is null', () => {
      beforeEach(() => {
        service.callback = null;
      });

      it('does not call any cleanup methods', 0, () => {
        service.onDestroy();
        expect(mockEventMgr.offAll).not.toHaveBeenCalled();
        expect(log.showInfo).not.toHaveBeenCalled();
        expect(notificationConfigManager.unsubscribeChangeEvent).not.toHaveBeenCalled();
        expect(sEventManager.off).not.toHaveBeenCalled();
      });
    });

    describe('when callback exists', () => {

      it('performs all cleanup operations', 0, () => {
        service.onDestroy();
        expect(mockEventMgr.offAll).toHaveBeenCalled();
        expect(log.showInfo).toHaveBeenCalledWith(`destroy entry, list size: ${service.ntfAdapterList.length}`);
        expect(service.callback).assertNull();
        expect(service.unsubscribeDropdown).toHaveBeenCalled();
        expect(notificationConfigManager.unsubscribeChangeEvent)
          .toHaveBeenCalledWith(service.onNotificationConfigChange);
        expect(SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks).toHaveBeenCalledWith(
          service.screenPropertyChangeCB,
          undefined,
          true,
          'dropdown-id'
        );
        expect(sEventManager.off).toHaveBeenCalledWith(REFRESH_STATUS_BAR_NTF, service.onRefreshStatusBarNtf);
      });

      describe('when isOuterHome is true', () => {

        beforeEach(() => {
          jest.spyOn(global, 'isOuterHome').mockReturnValue(true);
          service.listContentConfig = {
            isFilterNtfAfterScreenLockChangeSet: new Set()
          };
          service.listContentConfig.isFilterNtfAfterScreenLockChangeSet.add(
            service.onIsFilterNtfAfterScreenLockChange);
        });

        it('removes the filter callback from the set', 0, () => {
          service.onDestroy();
          expect(service.listContentConfig.isFilterNtfAfterScreenLockChangeSet.has(
            service.onIsFilterNtfAfterScreenLockChange))
            .assertEqual(false);
        });
      });
    });

    it('handles unsubscribeDropdown when it is undefined', 0, () => {
      service.unsubscribeDropdown = undefined;
      service.onDestroy();
      expect(service.unsubscribeDropdown).assertNull();
    });
  });

  describe('NotificationService', () => {
    let service: NotificationService;
    let mockDisplayCallback: DisplayCallback;
    let mockNtfListChangeCallback: NtfListChangeCallback;

    beforeEach(() => {
      service = new NotificationService();
      mockDisplayCallback = {
        onNtfStyleChange: jest.fn(),
      };
      mockNtfListChangeCallback = jest.fn();
    });

    describe('registerDisplayListener', () => {

      it('register_display_listener_adds_callback_and_calls_on_ntf_style_change', 0, () => {
        service.registerDisplayListener(mockDisplayCallback);
        expect([...service.displayCallback.values()]).assertContain(mockDisplayCallback);
        expect(mockDisplayCallback.onNtfStyleChange).toHaveBeenCalledWith(service.ntfStyle);
      });

      it('register_display_listener_does_not_add_duplicate_callbacks', 0, () => {
        service.registerDisplayListener(mockDisplayCallback);
        service.registerDisplayListener(mockDisplayCallback);
        expect([...service.displayCallback.values()]).assertEqual(1);
      });

      it('register_display_listener_does_nothing_if_callback_is_null', 0, () => {
        service.registerDisplayListener(null as any); // 类型强制转换
        expect([...service.displayCallback.values()]).toHaveLength(0);
      });
    });

    describe('unregisterDisplayListener', () => {

      it('unregister_display_listener_removes_callback', 0, () => {
        service.registerDisplayListener(mockDisplayCallback);
        service.unregisterDisplayListener(mockDisplayCallback);
        expect([service.displayCallback.values()]).assertContain(mockDisplayCallback);
      });

      it('unregister_display_listener_does_nothing_for_nonexistent_callback', 0, () => {
        service.unregisterDisplayListener(mockDisplayCallback);
        expect([service.displayCallback.values()]).toHaveLength(0);
      });
    });

    describe('registerNtfListChangeListener', () => {

      it('register_ntf_list_change_listener_adds_callback', 0, () => {
        service.registerNtfListChangeCallback(mockNtfListChangeCallback);
        expect([service.ntfListChangeCallback.values()]).assertContain(mockNtfListChangeCallback);
      });

      it('register_ntf_list_change_listener_does_not_add_duplicate_callbacks', 0, () => {
        service.registerNtfListChangeCallback(mockNtfListChangeCallback);
        service.registerNtfListChangeCallback(mockNtfListChangeCallback);
        expect([service.ntfListChangeCallback.values()]).toHaveLength(1);
      });

      it('register_ntf_list_change_listener_does_nothing_if_callback_is_null', 0, () => {
        service.registerNtfListChangeCallback(null as any); // 类型强制转换
        expect([service.ntfListChangeCallback.values()]).toHaveLength(0);
      });
    });

    describe('unregisterNtfListChangeListener', () => {

      it('unregister_ntf_list_change_listener_removes_callback', 0, () => {
        service.registerNtfListChangeCallback(mockNtfListChangeCallback);
        service.unregisterNtfListChangeCallback(mockNtfListChangeCallback);
        expect([service.ntfListChangeCallback.values()]).not.assertContain(mockNtfListChangeCallback);
      });

      it('unregister_ntf_list_change_listener_does_nothing_for_nonexistent_callback', 0, () => {
        service.unregisterNtfListChangeCallback(mockNtfListChangeCallback);
        expect([service.ntfListChangeCallback.values()]).toHaveLength(0);
      });
    });
  });

  describe('isNtfExists_unit_test', () => {

    let ntfListVm: NtfListVm;
    beforeEach(() => {
      ntfListVm = new NtfListVm();
      ntfListVm.ntfDictMap = new Map(); // 初始化空Map
    });

    // 测试存在hashCode的情况
    it('test_is_ntf_exists_existing_hashcode', 0, () => {
      const existingHashCode = 'existing_123';
      ntfListVm.ntfDictMap.set(existingHashCode, {}); // 模拟存在该通知
      const result = ntfListVm.isNtfExists(existingHashCode);
      expect(result).assertTrue();
    });

    // 测试不存在hashCode的情况
    it('test_is_ntf_exists_non_existing_hashcode', 0, () => {
      const nonExistingHashCode = 'non_existing_456';
      const result = ntfListVm.isNtfExists(nonExistingHashCode);
      expect(result).assertFalse();
    });
  });

  describe('getNtfListAdapter_unit_test', () => {
    let ntfListVm: NtfListVm;
    let mockAdapter: NotificationListAdapter;

    beforeEach(() => {
      ntfListVm = new NtfListVm();
      mockAdapter = new NotificationListAdapter(); // 模拟适配器实例
      ntfListVm.ntfAdapter = mockAdapter; // 设置被测对象的适配器
    });

    // 测试适配器存在的情况
    it('test_get_ntf_list_adapter_exists', 0, () => {
      const result = ntfListVm.getNtfListAdapter();
      expect(result).assertEqual(mockAdapter); // 验证返回的是同一个实例
    });

    // 测试适配器未初始化的情况（如果允许null/undefined）
    it('test_get_ntf_list_adapter_null', 0, () => {
      ntfListVm.ntfAdapter = null!; // 强制设置为null（根据实际类型调整）
      const result = ntfListVm.getNtf_listAdapter();
      expect(result).assertNull(); // 验证返回null
    });
  });
}