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
import { LogHelper } from '@ohos/basicutils';
import { describe, it, expect, MockKit, when, ArgumentMatchers, beforeEach, afterEach} from '@ohos/hypium';
import { BaseNotification } from '@ohos/systemuicommon/src/main/ets/model/BaseNotification';
import { ExclusiveChecker } from '../../../../main/ets/model/ExclusiveChecker';
import sceneSessionManager from '@ohos.sceneSessionManager';

export default function ExclusiveCheckerTest() {
  describe('isNotification_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });
  });

  describe('check_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_exclusive_when_result_is_true_and_details_is_valid', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();
      let bundleName: string = "com.example.app";
      let mode: 'FLOATING' | 'FULL_SCREEN' = 'FLOATING';
      let showToast: boolean = true;

      interface RssData {
        result: boolean;
        details?: string;
      }

      let mockRssData: RssData = {
        result: true,
        details: "com.example.app2"
      };

      let mockResult: Record<string, string> = {
        bundleName,
        mode
      };

      when(sceneSessionManager.getRssData)(ArgumentMatchers.anyString).afterReturn(mockRssData);
      let result: ExclusiveChecker = ExclusiveChecker.check(bundleName, mode, showToast);
      expect(result.result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_exclusive_when_result_is_true_and_details_is_invalid', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let bundleName: string = "com.example.app";
      let mode: 'FLOATING' | 'FULL_SCREEN' = 'FLOATING';
      let showToast: boolean = true;

      interface RssData {
        result: boolean;
        details?: string;
      }

      let mockRssData: RssData = {
        result: true,
        details: "com.example.app2"
      };
      when(sceneSessionManager.getRssData)(ArgumentMatchers.anyString).afterReturn(mockRssData);
      let result: ExclusiveChecker = ExclusiveChecker.check(bundleName, mode, showToast);
      expect(result.result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_exclusive_when_result_is_false_and_details_is_valid', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let bundleName: string = "com.example.app";
      let mode: 'FLOATING' | 'FULL_SCREEN' = 'FLOATING';
      let showToast: boolean = true;

      interface RssData {
        result: boolean;
        details?: string;
      }

      let mockRssData: RssData = {
        result: false,
        details: "com.example.app2"
      };

      let mockResult: Record<string, string> = {
        bundleName,
        mode
      };

      when(sceneSessionManager.getRssData)(ArgumentMatchers.anyString,).afterReturn(mockRssData);

      let result: ExclusiveChecker = ExclusiveChecker.check(bundleName, mode, showToast);

      expect(result.result).assertEqual(false);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_exclusive_when_result_is_true_and_details_is_valid_and_showToast_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockShowExclusiveToast: Function =
        mocker.mockFunc(ExclusiveChecker, ExclusiveChecker.prototype.showExclusiveToast);
      when(mockShowExclusiveToast)().afterReturnNothing();

      let mockError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let bundleName: string = "com.example.app";
      let mode: 'FLOATING' | 'FULL_SCREEN' = 'FLOATING';
      let showToast: boolean = true;

      interface RssData {
        result: boolean;
        details?: string;
      }

      let mockRssData: RssData = {
        result: false,
        details: "com.example.app2"
      };

      let mockResult: Record<string, string> = {
        bundleName,
        mode
      };

      when(sceneSessionManager.getRssData)(ArgumentMatchers.anyString,).afterReturn(mockRssData);

      let result: ExclusiveChecker = ExclusiveChecker.check(bundleName, mode, showToast);

      expect(result.result).assertEqual(false);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });
  });
}
