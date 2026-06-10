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

import { AppItemInfo, FolderAppItemInfo, GridLayoutItemBuilder, GridLayoutItemInfo } from '../../../TsIndex';

/**
 * 文件夹公共常量类
 */
export class FolderCommonConstants {
  // 该图标在对应文件夹折叠态中的偏移参数和缩放大小
  public static readonly aniParameters: number[] = [0, 0, 1, 1];

  // 拖拽热区宽度
  public static readonly FOLDER_ZOOM_HOT_AREA_SIDE_WIDTH: number = 32;

  // 触发长按按压动效时长
  public static readonly LONG_PRESS_TRIGGER_ANIMATION: number = 550;

  /**
   * 异常文件夹id
   */
  public static readonly INVALID_FOLDER_ID: string = '-1';

  public static readonly FEATURE_NAME_SMALL_FOLDER: string = 'featureSmallFolder';

  public static readonly FEATURE_NAME_BIG_FOLDER: string = 'featureBigFolder';

  public static readonly FEATURE_NAME_DESKTOP: string = 'pageDesktop';

  public static readonly FEATURE_NAME_FORM: string = 'featureForm';

  /**
   * small folder page app length
   */
  public static readonly DEFAULT_FOLDER_PAGE_LENGTH: number = 12;

  /**
   * small folder middle app icon index
   */
  public static readonly DEFAULT_FOLDER_MIDDLE_INDEX: number = 4;

  /**
   * small folder show app icon length
   */
  public static readonly DEFAULT_FOLDER_SHOW_LENGTH: number = 9;

  // 创建文件夹弹出推荐弹框
  public static readonly OPEN_ADD_SHEET_CREATE_FOLDER: string = 'smallFolder';

  // 点击添加按钮弹出推荐弹框
  public static readonly OPEN_ADD_SHEET_ADD_BUBBLE: string = 'folderAddSheetEvent';

  // 4X2文件夹area
  public static readonly FOLDER_AREA_4X2: number[] = [4, 2];

  // 2X2文件夹area
  public static readonly FOLDER_AREA_2X2: number[] = [2, 2];

}

/**
 * 回调优先级
 */
export enum FolderLifeCyclePriority {
  /* 低优先级，主要用于相关的布局控件刷新 */
  LOW = 1,
  /* 正常优先级，用于控件刷新前的控制变量变更 */
  NORMAL = 50,
  /* 高优先级，用于缓存数据的变更刷新 */
  HIGH = 90,
  /* 最高优先级，仅用于data/viewModel的数据更新 */
  HIGHER = 100,
}

export enum FolderDataRefreshType {
  DESKTOP,
  DOCK,
  FOLDER
}

/**
 * 点击类型
 */
export enum FolderClickType {
  ICON_CLICK,
  GRID_CLICK
}

/**
 * 拖拽落位位置
 */
export enum FolderDropType {
  DROP_IN_FOLDER,
  DROP_CREATE_FOLDER,
  MULTI_DROP_CREATE,
  DROP_REFRESH_FOLDER,
  DROP_REFRESH_DOCK,
  DROP_TO_DESKTOP,
  DROP_BACK
}

/**
 * 文件位置类型dock区或桌面文件夹
 */
export enum COVER_FOLDER_TYPE {
  DOCK_FOLDER,
  DESKTOP_FOLDER
}

/**
 * layout属性状态变量
 */
export enum ATTRIBUTE_TYPE {
  OPACITY,
  SCALE,
  SCALE_X,
  SCALE_Y,
  TRANS_X,
  TRANS_Y,
  OFFSET_X,
  OFFSET_Y,
  WIDTH,
  HEIGHT,
  BORDER_RADIUS,
}

/**
 * 文件夹子组件observer类型
 */
export enum OBSERVER_TYPE {
  /* 文件夹包含文件夹 */
  FOLDER,
  /* 文件夹图标不含文件夹名字 */
  FOLDER_ICON,
  /* 文件夹背板 */
  FOLDER_BG,
  /* 动效图标 */
  ANI_ICON,
  /* 第一个堆叠图标 */
  SP_ICON_FST,
  /* 第二个堆叠图标 */
  SP_ICON_SND,
  /* 第三个个堆叠图标 */
  SP_ICON_TRD,
  /* 第一个占位图标 */
  PH_ICON_FST,
  /* 第二个占位图标 */
  PH_ICON_SND,
  /* 动效图标 */
  ICON_DATA,
  /* 动效图标 */
  SND_ICON_DATA,
  /* 文件夹调整大小 */
  FOLDER_RESIZE
}

/**
 * 文件夹开关状态变量类型
 */
export enum OBSERVER_SWITCH {
  /* 菜单显示开关 */
  MENU_SHOW,
  /* 菜单模糊显示开关 */
  MENU_EFFECT_HIDE,
  /* 大小转换动画开关 */
  FOLDER_CHANGE,
  /* 文件夹可见性开关 */
  FOLDER_VISIBLE,
  /* 下载进度显示开关 */
  PROGRESS_SHOW,
  /* 下载背板显示开关 */
  DOWNLOAD_MASK,
  /* 尾页显示开关 */
  END_PAGE_SHOW,
  /* 当前页显示开关 */
  CURRENT_PAGE_SHOW,
  /* 堆叠退出动效图标显示开关 */
  LAST_APP_SHOW,
  /* 大小调整动画开关 */
  RESIZE_ANIMATE,
  /* 文件夹编辑态显示开关 */
  EDIT_FOLDER_MODE,
  /* 拖拽应用到文件夹动画开关 */
  ICON_ANIMATE,
  /* 文件夹选择框 */
  FOLDER_CHECK_BOX,
  /* 大小转换动效 */
  CONVERT_ANIMATE
}

/**
 * 文件夹数据状态变量类型
 */
export enum OBSERVER_DATA {
  /* 文件夹首页显示数据 */
  FIRST_PAGE_DATA,
  /* 文件夹尾页显示数据 */
  END_PAGE_DATA,
  /* 文件夹当前页显示数据 */
  CURRENT_PAGE_DATA,
  /* 文件夹调整大小隐藏图标 */
  HIDE_ITEMS_DATA
}

/**
 * 文件夹不同大小的非堆叠显示图标数量
 */
export enum FolderType {
  AREA_2X1_1X2 = 2,
  AREA_4X2 = 17,
  AREA_2X2_1X1 = 8
}

/**
 * 菜单参数数据信息类
 */
export class MenuDataOption {
  layoutRegionMargin: Margin | undefined;
  offset: Position | undefined;
  onDisappearCallback: () => void = (): void => {};
  preAnimationStartScale: number | undefined;
  preAnimationEndScale: number | undefined;
  isHiddenEffect: boolean | undefined;
  placement: number | undefined;
  onWillAppear: () => void = (): void => {};
  onWillDisappear: () => void = (): void => {};
}