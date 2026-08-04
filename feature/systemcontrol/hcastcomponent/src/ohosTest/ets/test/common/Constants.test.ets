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

import { describe, expect, it, Level } from '@ohos/hypium';
import Constants from '../../../../main/ets/com/ohos/common/Constants';

export function ConstantsTest() {
  describe('ConstantsTest', (): void => {
    it('ConstantsTest_CAST_BUNDLE_NAME', Level.LEVEL1, () => {
      let constantName = Constants.CAST_BUNDLE_NAME;
      let constantValue = 'com.ohos.ohcast';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_CONTROL_CENTER_CLICK_CODE', Level.LEVEL1, () => {
      let constantName = Constants.CONTROL_CENTER_CLICK_CODE;
      let constantValue = 1002;
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_CONTROL_CENTER_PHONE_CLICK_CODE', Level.LEVEL1, () => {
      let constantName = Constants.CONTROL_CENTER_PHONE_CLICK_CODE;
      let constantValue = 1006;
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_CAST_PRIVACY_VERSION', Level.LEVEL1, () => {
      let constantName = Constants.CAST_PRIVACY_VERSION;
      let constantValue = 'wireless_projection_privacy_agree';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_CONTROL_CENTER_RESHOW_PRIVACY', Level.LEVEL1, () => {
      let constantName = Constants.CONTROL_CENTER_RESHOW_PRIVACY;
      let constantValue = 'need_reshow_projection_privacy';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_PUBLISH_EVENT_CAST_CONNECTED', Level.LEVEL1, () => {
      let constantName = Constants.PUBLISH_EVENT_CAST_CONNECTED;
      let constantValue = 'ohcast.event.CAST_CONNECTED';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_PUBLISH_EVENT_CAST_DISCONNECTED', Level.LEVEL1, () => {
      let constantName = Constants.PUBLISH_EVENT_CAST_DISCONNECTED;
      let constantValue = 'ohcast.event.CAST_DISCONNECTED';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_PUBLISH_EVENT_CAST_DISCONNECT_DEVICE', Level.LEVEL1, () => {
      let constantName = Constants.PUBLISH_EVENT_CAST_DISCONNECT_DEVICE;
      let constantValue = 'ohcast.event.DISCONNECT_DEVICE';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_PUBLISH_EVENT_GET_CONNECT_STATE', Level.LEVEL1, () => {
      let constantName = Constants.PUBLISH_EVENT_GET_CONNECT_STATE;
      let constantValue = 'ohcast.event.CAST_GET_CONNECT_STATE';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_PUBLISH_EVENT_CLOSE_CAST_DIALOG', Level.LEVEL1, () => {
      let constantName = Constants.PUBLISH_EVENT_CLOSE_CAST_DIALOG;
      let constantValue = 'ohcast.event.CLOSE_CAST_DIALOG';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_PUBLISH_PERMISSION_MIRROR', Level.LEVEL1, () => {
      let constantName = Constants.PUBLISH_PERMISSION_MIRROR;
      let constantValue = 'ohos.permission.ACCESS_CAST_ENGINE_MIRROR';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_PRIVACY_VERSION_DEFAULT', Level.LEVEL1, () => {
      let constantName = Constants.PRIVACY_VERSION_DEFAULT;
      let constantValue = '0';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_PRIVACY_VERSION_NEWEST', Level.LEVEL1, () => {
      let constantName = Constants.PRIVACY_VERSION_NEWEST;
      let constantValue = '1';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_PUBLISH_EVENT_DIALOG_SHOW', Level.LEVEL1, () => {
      let constantName = Constants.PUBLISH_EVENT_DIALOG_SHOW;
      let constantValue = 'ohcast.event.CAST_DIALOG_SHOW';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_PUBLISH_EVENT_CLOSE_SUB_WINDOW', Level.LEVEL1, () => {
      let constantName = Constants.PUBLISH_EVENT_CLOSE_SUB_WINDOW;
      let constantValue = 'ohcast.event.CLOSE_SUB_WINDOW';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_PUBLISH_EVENT_OPEN_SUB_WINDOW', Level.LEVEL1, () => {
      let constantName = Constants.PUBLISH_EVENT_OPEN_SUB_WINDOW;
      let constantValue = 'ohcast.event.OPEN_SUB_WINDOW';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_DIALOG_DEFAULT', Level.LEVEL1, () => {
      let constantName = Constants.DIALOG_DEFAULT;
      let constantValue = 0;
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_DIALOG_PRIVACY', Level.LEVEL1, () => {
      let constantName = Constants.DIALOG_PRIVACY;
      let constantValue = -100001;
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_DIALOG_WIFI_BLUETOOTH', Level.LEVEL1, () => {
      let constantName = Constants.DIALOG_WIFI_BLUETOOTH;
      let constantValue = -100002;
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_LAST_CONNECTED_DEV_ID', Level.LEVEL1, () => {
      let constantName = Constants.LAST_CONNECTED_DEV_ID;
      let constantValue = 'last_connected_device_id';
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_REPORT_DIALOG_SHOW', Level.LEVEL1, () => {
      let constantName = Constants.REPORT_DIALOG_SHOW;
      let constantValue = 0;
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_REPORT_DIALOG_CONFIRM', Level.LEVEL1, () => {
      let constantName = Constants.REPORT_DIALOG_CONFIRM;
      let constantValue = 1;
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_REPORT_DIALOG_CANCEL', Level.LEVEL1, () => {
      let constantName = Constants.REPORT_DIALOG_CANCEL;
      let constantValue = 2;
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_MAX_RETRY_CONNECT_TIMES', Level.LEVEL1, () => {
      let constantName = Constants.MAX_RETRY_CONNECT_TIMES;
      let constantValue = 3;
      expect(constantName === constantValue).assertTrue();
    });

    it('ConstantsTest_TIBETAN_LANGUAGES', Level.LEVEL1, () => {
      let constantName = Constants.TIBETAN_LANGUAGES;
      let constantValue = 'bo';
      expect(constantName[0] === constantValue).assertTrue();
    });
  })
}