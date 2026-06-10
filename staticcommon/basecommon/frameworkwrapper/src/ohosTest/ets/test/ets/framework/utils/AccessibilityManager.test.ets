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

import { afterAll, afterEach,
  ArgumentMatchers,
  beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { AccessibilityManager } from '../../../../../../main/ets/TsIndex';
import accessibility from '@ohos.accessibility';

export function AccessibilityManagerTest() {
  describe('AccessibilityManagerTest', () => {
    beforeAll((): void => {
      globalThis.accessibilityManager = null;
    })

    beforeEach((): void => {

    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('initAccessibilityModeListener', 0, () => {
      AccessibilityManager.getInstance()['isListenerHasRegistered'] = true;
      AccessibilityManager.getInstance().initAccessibilityModeListener();
      AccessibilityManager.getInstance()['isListenerHasRegistered'] = false;
      expect(AccessibilityManager.getInstance()['isListenerHasRegistered']).assertFalse()
    })

    it('test_initAccessibilityModeListener_mock', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(AppStorage, AppStorage.setOrCreate);
      when(mockFun)(ArgumentMatchers.any).afterThrow('mock error');

      AccessibilityManager.getInstance().initAccessibilityModeListener();
      expect(AccessibilityManager.getInstance()).not().assertUndefined();
      mocker.clear(AppStorage);
      mocker.ignoreMock(AppStorage, AppStorage.setOrCreate);
      mocker.clearAll();
    })

    it('updateAccessibilityMode', 0, () => {
      AccessibilityManager.getInstance()['updateAccessibilityMode'](true);
      AccessibilityManager.getInstance()['isAccessibilityScreenReaderEnable'] = false;
      expect(AccessibilityManager.getInstance()['isAccessibilityScreenReaderEnable']).assertFalse()
    })

    it('test_sendTextAnnouncedForAccessibility', 0, () => {
      AccessibilityManager.getInstance().sendTextAnnouncedForAccessibility('for test', 'test');
      expect(AccessibilityManager.getInstance()).not().assertUndefined();
    })

    it('test_requestFocusForAccessibility', 0, () => {
      AccessibilityManager.getInstance().requestFocusForAccessibility('for test', 'test');
      expect(AccessibilityManager.getInstance()).not().assertUndefined();
    })

    it('test_requestFocusAccessibility', 0, () => {
      const APPGRID_FOCUS_ID: string = 'EmergencyAppGrid_0';
      const DIALOG_TITLE_ID = 'OpenFolderAddDialog_Title';
      AccessibilityManager.getInstance().requestFocusAccessibility('for test');
      AccessibilityManager.getInstance().requestFocusAccessibility(APPGRID_FOCUS_ID);
      AccessibilityManager.getInstance().requestFocusAccessibility(DIALOG_TITLE_ID);
      expect(AccessibilityManager.getInstance()).not().assertUndefined();
    })

    it('test_sendAccessibilityEvent', 0, () => {
      let accessEventInfo: accessibility.EventInfo =
        new accessibility.EventInfo('announceForAccessibility', 'com.ohos.sceneboard.dt', 'common');
      accessEventInfo.textAnnouncedForAccessibility = 'text';
      AccessibilityManager.getInstance()['sendAccessibilityEvent'](accessEventInfo, 'test', '');
      expect(AccessibilityManager.getInstance()).not().assertUndefined();
    })
  })
}