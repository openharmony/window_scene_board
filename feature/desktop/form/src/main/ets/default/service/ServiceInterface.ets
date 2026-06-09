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
import { Position } from '@kit.ArkUI';
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';

/**
 * 请求方法
 */
export const enum RequestMethod {
  /**
   * 打开卡片中心页面
   */
  OPEN_FORM_CENTER_VIEW = 'openFormCenterView',

  /**
   * 关闭卡片中心页面
   */
  CLOSE_FORM_CENTER_VIEW = 'closeFormCenterView',

  /**
   * 打开卡片管理页面
   */
  OPEN_FORM_MANAGE_VIEW = 'openFormManageView',

  /**
   * 关闭卡片管理页面
   */
  CLOSE_FORM_MANAGE_VIEW = 'closeFormManageView',

  /**
   * 播放添加卡片动效
   */
  PLAY_ADD_FORM_ANIMATION = 'playAddFormAnimation',

  /**
   * 打开卡片编辑页面
   */
  OPEN_FORM_EDIT_VIEW = 'openFormEditView',

  /**
   * 关闭卡片编辑页面
   */
  CLOSE_FORM_EDIT_VIEW = 'closeFormEditView',

  /**
   * 打开卡片编辑二级页面
   */
  OPEN_FORM_EDIT_SEC_PAGE_VIEW = 'openFormEditSecPageView',

  /**
   * 关闭卡片编辑二级页面
   */
  CLOSE_FORM_EDIT_SEC_PAGE_VIEW = 'closeFormEditSecPageView',

  /**
   * 通过互动卡片启动应用
   */
  START_ABILITY_BY_LIVE_FORM = 'startAbilityByLiveForm',
}

/**
 * 请求消息
 */
export interface CallMessage {
  /**
   * 方法名, 对应RequestMethod
   */
  method: string;

  /**
   * 附加参数
   */
  extra: object;
}

/**
 * 卡片管理页返回结果
 */
export enum FormManageResponse {
  /**
   * 卡片管理界面关闭
   */
  CLOSE_FORM_MANAGER = 0,

  CREATE_FORM_SUCCESS,

  CREATE_FORM_FAILED,

  CREATE_FORM_LIMIT,

  NO_ENOUGH_AREA
}

/**
 * 卡片管理页返回结果
 */
export interface SubFormManageResponse {
  /**
   * 卡片管理返回码
   */
  code: FormManageResponse;

  /**
   * 卡片管理返回加卡信息
   */
  formInfo?: CardItemInfo;

  /**
   * 卡片初始位置
   */
  startPosition?: Position;
}

/**
 * 卡片中心页返回状态码
 */
export enum FormCenterResponseCode {
  /**
   * 卡片中心页面关闭
   */
  CLOSE_FORM_CENTER = 0,

  ADD_FORM,

  DRAG_FORM_START,

  CREATE_FORM_SUCCESS,

  CREATE_FORM_FAILED,

  JUMP_TO_FORM_MANAGER,

  BACK_TO_FORM_CENTER,

  CREATE_FORM_LIMIT,

  NO_ENOUGH_AREA,

  DROP_ANIMATION_END,

  DRAG_FORM_END
}

/**
 * 卡片中心页返回结果
 */
export interface FormCenterResponse {
  /**
   * 卡片中心返回码
   */
  code: FormCenterResponseCode;

  /**
   * 卡片中心返回加卡信息
   */
  formInfo?: CardItemInfo;

  /**
   * 卡片初始位置
   */
  startPosition?: Position;
}

/**
 * 播放卡片添加动效起始和结束位置数据
 */
export interface AddFormAnimationData {
  key: string,
  startPosition: Position,
  endPosition: Position,
  color: string,
  isLightWallpaper: boolean,
  scaleX: number,
  scaleY: number,
  index: number
}

export interface ServiceCallbackResult {
  isAddCardSuccess: boolean;
}

/**
 * 服务侧返回的信息
 */
export class ServiceReturnMsg {
  public static readonly RET_INVALID_JSON_DATA: string = 'failed: invalid json data';

  public static readonly RET_INVALID_EXTRA_DATA: string = 'failed: invalid extra data';

  public static readonly RET_INVALID_METHOD: string = 'failed: invalid method';

  public static readonly RET_UNKNOWN_METHOD: string = 'failed: unknown method';

  public static readonly RET_SUCCESS: string = 'success';
}