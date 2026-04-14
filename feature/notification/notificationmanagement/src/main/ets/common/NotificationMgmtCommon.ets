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
import { notificationManager } from '@kit.NotificationKit';

export interface SimpleBundleInfo {
  name: string;
  icon: DrawableDescriptor | string;
  version: string;
  uid?: number;
}

export interface NtfReminderViewData {
  labelState: LabelState;
  img?: Resource;
}

export interface LabelState {
  label: ResourceStr;
  state: boolean;
}

export enum RemindType {
  /* 锁屏通知 */
  LOCK_SCREEN,
  /* 横幅通知 */
  BANNER,
  /* 桌面角标 */
  DESKTOP_CORNER,
  /* 响铃 */
  SOUND,
  /* 震动 */
  VIBRATION
}

export enum SlotType {
  /* 社交通信 */
  SOCIAL_COMMUNICATION,
  /* 服务提醒 */
  SERVICE_INFORMATION,
  /* 内容资讯 */
  CONTENT_INFORMATION,
  /* 客服消息 */
  CUSTOMER_SERVICE,
  /* 其他 */
  OTHER
}

export enum LockScreenNtfStyle {
  /* 列表态 */
  LIST,
  /* 收纳态 */
  DOWN
}

export interface CommonProperties {
  margin?: Margin;
  border?: BorderOptions;
  width?: Length;
  height?: Length;
  bgColor?: ResourceColor;
  padding?:Padding;
}

const model2ViewDataSlotTypeMapping: Map<notificationManager.SlotType, SlotType> = new Map([
  [notificationManager.SlotType.SOCIAL_COMMUNICATION, SlotType.SOCIAL_COMMUNICATION],
  [notificationManager.SlotType.SERVICE_INFORMATION, SlotType.SERVICE_INFORMATION],
  [notificationManager.SlotType.CONTENT_INFORMATION, SlotType.CONTENT_INFORMATION],
  [notificationManager.SlotType.CUSTOMER_SERVICE, SlotType.CUSTOMER_SERVICE],
  [notificationManager.SlotType.OTHER_TYPES, SlotType.OTHER]
])

export function getViewDataSlotType(slot: notificationManager.NotificationSlot): SlotType | undefined {
  return slot.notificationType ? model2ViewDataSlotTypeMapping.get(slot.notificationType) : undefined;
}

const viewData2ModelSlotTypeMapping: Map<SlotType, notificationManager.SlotType> = new Map([
  [SlotType.SOCIAL_COMMUNICATION, notificationManager.SlotType.SOCIAL_COMMUNICATION],
  [SlotType.SERVICE_INFORMATION, notificationManager.SlotType.SERVICE_INFORMATION],
  [SlotType.CONTENT_INFORMATION, notificationManager.SlotType.CONTENT_INFORMATION],
  [SlotType.CUSTOMER_SERVICE, notificationManager.SlotType.CUSTOMER_SERVICE],
  [SlotType.OTHER, notificationManager.SlotType.OTHER_TYPES]
])

export function getModelSlotType(slotType: SlotType): notificationManager.SlotType | undefined {
  return viewData2ModelSlotTypeMapping.get(slotType);
}

const soltLabelMap = new Map([
  [SlotType.SOCIAL_COMMUNICATION, $r('app.string.slot_social_communication')],
  [SlotType.SERVICE_INFORMATION, $r('app.string.slot_service_information')],
  [SlotType.CONTENT_INFORMATION, $r('app.string.slot_content_information')],
  [SlotType.CUSTOMER_SERVICE, $r('app.string.slot_customer_service_message')],
  [SlotType.OTHER, $r('app.string.slot_other')]
])

export function getLabelBySlotType(type: SlotType): ResourceStr {
  return soltLabelMap.get(type) ?? '';
}

const viewDataRemindType2ModelFlagsIdxMapping: Map<RemindType, number> = new Map([
  [RemindType.SOUND, 0],
  [RemindType.LOCK_SCREEN, 1],
  [RemindType.BANNER, 2],
  [RemindType.VIBRATION, 4],
]);

export function getIdxInModelFlags(type: RemindType): number | undefined {
  return viewDataRemindType2ModelFlagsIdxMapping.get(type);
}

export enum ExtensionResult {
  SUCCESS = 0,
  PARAM_ERROR = 401,
  GET_BUNDLE_INFO_ERROR = 501,
}

export enum SwitchKey {
  ALLOW = 'Allow',
  PIN_TOP = 'PinTop',
  SLOTS = 'Slots',
  BADGE = 'Badge',
  SILENCE = 'Silence',
}

export class NotificationConstants {
  /**
   * 应用内通知管理linkFeature
   */
  public static readonly APP_NTF_MGMT = 'AppNotificationMgmt';
}