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
/**
 * 通知面板类型
 */
export enum NotificationType {
  /**
   * 手机下拉面板
   */
  TYPE_PHONE_DROPDOWN = 2,
  /**
   * 手机锁屏面板
   */
  TYPE_PHONE_KEYGUARD = 3,
  /**
   * 通知类型，PhoneAOD面板
   */
  TYPE_PHONE_AOD = 4,
  /**
   * 手机实况面板
   */
  TYPE_PHONE_LIVELIST = 5,
}