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

import { AppItem, StateValue } from '@ohos/managementcomponent/src/main/ets/com/ohos/vm/appLstComponentViewModel';
import { describe, beforeEach, afterEach, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveViewAppFilter } from '../../../../../main/ets/vm/LiveViewAppFilter';

export default function LiveViewAppFilterTest() {
  describe('getLiveViewApp_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });


    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_empty_list_when_appList_is_empty', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let appList: (AppItem | undefined)[] = [];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_filtered_list_when_appList_contains_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(1);
      expect(result[0].id).assertEqual(1);
      expect(result[0].name).assertEqual('App1');
      expect(result[0].state).assertEqual(StateValue.STATE_LIVE_VIEW);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_return_filtered_list_when_appList_contains_non_live_view_apps', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      let appList: (AppItem | undefined)[] = [
        {
          id: 1, name: 'App1', state: StateValue.STATE_LIVE_VIEW
        },
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });

    it('should_handle_undefined_app_items_in_appList', 0, async () => {
      let liveviewappfilter: LiveViewAppFilter = new LiveViewAppFilter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));

      let appList: (AppItem | undefined)[] = [
        undefined,
        {
          id: 2, name: 'App2', state: StateValue.STATE_NORMAL
        }
      ];
      const result = await liveviewappfilter.getLiveViewApp(appList);
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(liveviewappfilter, liveviewappfilter.isLiveViewEnable);
    });
  });
}