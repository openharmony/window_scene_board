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