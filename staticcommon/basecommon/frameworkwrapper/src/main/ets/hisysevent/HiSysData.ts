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

export class HiSysDataMediaCommand {
  static readonly PLAY: number = 0;
  static readonly PAUSE: number = 1;
  static readonly PLAY_PREVIOUS: number = 2;
  static readonly PLAY_NEXT: number = 3;
  static readonly JUMP_INSIDE: number = 4;
}

export class HiSysDataShowHide {
  static readonly HIDE: number = 0;
  static readonly SHOW: number = 1;
}

export class HiSysDataNotificationClickScene {
  static readonly LOCK_SCREEN: number = 1;
  static readonly HEADS_UP: number = 2;
  static readonly NTF_CENTER: number = 3;
}

export class HiSysDataNotifyClickState {
  static readonly UNLOCK_SINGLE_CLICK: number = 0;
  static readonly LOCK_SINGLE_CLICK: number = 1;
  static readonly LOCK_DOUBLE_CLICK: number = 2;
}

export class HiSysDataUserType {
  static readonly ADMIN: number = 1;
  static readonly USER: number = 2;
  static readonly GUEST: number = 3;
}

export class HiSysDataRingMode {
  static readonly SILENT: number = 0;
  static readonly VIBRATION: number = 1;
  static readonly NORMAL: number = 2;
}

export class HiSysDataOperationType {
  static readonly INSERT: string = 'insert';
  static readonly DELETE: string = 'delete';
}

export class HiSysDataOrientation {
  static readonly LANDSCAPE: number = 2;
  static readonly VERTICAL: number = 1;
}

export class HiSysDataResult {
  static readonly SUCCESS: string = 'success';
  static readonly FAIL: string = 'fail';
}

export class HiSysDataDirection {
  static readonly TO_LEFT: number = 1;
  static readonly TO_RIGHT: number = 2;
}

export class HiSysDataScreenLockLocation {
  static readonly LOCATION_RECOMMEND: number = 1;
  static readonly LOCATION_DETAIL: number = 2;
}

/**
 * back手势打点数据参数
 */
export class HiSysBackEventData {
  static readonly SUCCESS: string = 'success'; // back手势操作结果：成功
  static readonly CANCEL: string = 'cancel'; // back手势操作结果：取消
  static readonly LEFT: string = 'left'; // back手势操作方向：左侧
  static readonly RIGHT: string = 'right'; // back手势操作方向：右侧
}

/**
 * 上滑回桌面打点数据参数
 */
export class HiSysReturnHomeData {
  static readonly FROM_APP: string = 'APP'; // 从应用内上滑回桌面
  static readonly FROM_DESKTOP: string = 'DESKTOP'; // 从桌面上滑回桌面
}

/**
 * 底部手势快切打点数据参数
 */
export class HiSysGestureQuickSwitchData {
  static readonly FROM_APP: string = 'APP';
  static readonly FROM_DESKTOP: string = 'DESKTOP';
}

/**
 * 触发Dock消失的方式
 */
export class HiSysDockDisappearModeData {
  static readonly BLANK_AREA_CLICK: number = 0; //点击空白处
  static readonly BACK_GESTURE: number = 1; //back手势
  static readonly GESTURE_DOCK_LEFT_IN_RIGHT_OUT: number = 2; //左进右出
  static readonly GESTURE_DOCK_RIGHT_IN_LEFT_OUT: number = 3; //右进左出
}

/**
 * 侧边dock增加应用来源
 */
export class HiSysDockAddAppSourceData {
  static readonly EDIT_AREA: number = 0; //编辑区列表
  static readonly SEARCH_RESULT: number = 1; //搜索结果
}

/**
 * 侧边dock进入退出菜单类型
 */
export class HiSysDockEditType {
  static readonly EDIT: number = 1; //编辑区
  static readonly ALL_APPS: number = 2; //二级页面
}

/**
 * 误触长按导航条场景
 */
export class HiSysLongPressMisTouchType {
  static readonly MOVE: number = 0; // 滑动误触
  static readonly RETRACT: number = 1; // 用户在弹框全部出现前取消
}