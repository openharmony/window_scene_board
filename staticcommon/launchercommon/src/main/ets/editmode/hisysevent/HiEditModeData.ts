/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

export enum HiEditModeDataExitType {
  // 退出编辑模式方式：未知
  EXIT_UNKNOWN = 0,
  // 点击对勾按钮退出
  EXIT_OK = 1,
  // 息屏锁屏退出
  EXIT_SCREEN_OFF = 2,
  // 手势退出
  EXIT_GESTURE = 3,
  // 被其他应用全屏遮盖退出
  EXIT_FULLY_OCCLUSION = 4,
  // 点击空白处退出
  EXIT_BLANK_CLICKED = 5,
  // 手机旋转/折叠屏折叠展开
  EXIT_SCREEN_CHANGE = 6,
  // 双指捏合退出编辑模式
  EXIT_PINCH = 7
}

export enum HiEditModeDataEnterType {
  // 进入编辑模式方式：未知
  ENTER_UNKNOWN = 0,
  // 长按进入编辑模式
  ENTER_LONG_PRESS = 1,
  // 拖拽进入编辑模式
  ENTER_DRAGING = 2,
  // 双指捏合进入编辑模式
  ENTER_PINCH = 3
}

export enum HiEditModeDataUninstallType {
  // 卸载移除操作类型：单元素
  UNINSTALL_OPERATION_SINGLE = 0,
  // 卸载移除操作类型：多元素
  UNINSTALL_OPERATION_MULTI = 1
}

export enum HiEditModeDataUninstallObjType {
  // 卸载移除操作对象：单元素
  UNINSTALL_OBJECT_APP = 'app',
  // 卸载移除操作对象：多元素
  UNINSTALL_OBJECT_CARD = 'card'
}