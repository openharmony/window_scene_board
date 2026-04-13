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
import type { CommonEventSubscribeInfo } from 'commonEvent/commonEventSubscribeInfo';
import CommonEventManager from '@ohos.commonEventManager';
import commonEvent from '@ohos.commonEvent';

/**
 * 公共事件订阅信息常量
 */
export default class CommonEventConstants {
  /**
   * 凭证(密码/指纹/人脸)公共事件订阅信息
   */
  public static readonly CREDENTIAL_SUBSCRIBE_INFO: CommonEventSubscribeInfo = {
    events: ['USER_CREDENTIAL_UPDATED_EVENT'],
    publisherPermission: 'ohos.permission.MANAGE_USER_IDM'
  };

  /**
   * 主题公共事件订阅信息
   */
  public static readonly THEME_SUBSCRIBE_INFO: CommonEventSubscribeInfo = {
    events: [
      CommonEventManager.Support.COMMON_EVENT_PACKAGE_REMOVED
    ]
  };

  /**
   * 锁屏公共事件订阅信息
   */
  public static readonly SCREENLOCK_SUBSCRIBE_INFO: CommonEventSubscribeInfo = {
    events: [
      CommonEventManager.Support.COMMON_EVENT_PACKAGE_REMOVED
    ]
  };

  /**
   * 用户更新公共事件订阅信息
   */
  public static readonly USER_SUBSCRIBE_INFO: CommonEventSubscribeInfo = {
    events: [
      commonEvent.Support.COMMON_EVENT_USER_ADDED,
      commonEvent.Support.COMMON_EVENT_USER_REMOVED,
      'usual.event.USER_INFO_UPDATED'
    ],
  };

  public static readonly PKGCHANGE_SUBSCRIBE_INFO: CommonEventSubscribeInfo = {
    events: [
      commonEvent.Support.COMMON_EVENT_PACKAGE_ADDED,
      commonEvent.Support.COMMON_EVENT_PACKAGE_REMOVED
    ]
  };
}