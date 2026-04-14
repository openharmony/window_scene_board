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
import type { LiveUseScene } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import type { NotificationEntry } from '../model/NotificationEntry';

/**
 * 通知常量
 *
 * @since 2023-03-03
 */
export class NotificationConstants {
  /**
   * eventManager通知 锁屏页面监听组通知是否有展开
   */
  public static readonly PHONE_LOCK_IS_GROUP_EXPANDED: string = 'phoneLockIsGroupExpanded';

  /**
   * eventManager通知 触发收起组通知
   */
  public static readonly ntfFoldGroupItem: string = 'ntfFoldGroupItem';

  /**
   * 不允许关闭通知白名单
   */
  public static readonly DISABLE_CLOSE_NOTIFICATION_PACKAGE_NAME: Array<string> = ['ohos.global.systemres'];

  /**
   * 屏蔽"关闭此应用通知"按钮白名单
   */
  public static readonly DISABLE_CLOSE_BUTTON_PACKAGE_NAME: Set<string> = new Set(['com.ohos.mms']);

  public static readonly NTF_LOG_PREFIX: string = '[SysUI_NTF]';

  /**
   * 默认展开通知按钮白名单
   */
  public static readonly DEFAULT_EXPAND_BUTTON_PACKAGE_NAME: Set<string> = new Set(['com.ohos.parentcontrol']);

  /**
   * 默认展开通知按钮持续时间(小时)
   */
  public static readonly EXPAND_BUTTON_DURATION = 6;

  /**
   * 锁屏通知图标最大显示个数
   */
  public static readonly maxIconNumber: number = 3;
  /**
   * 锁屏通知图形下文件最大显示个数
   */
  public static readonly maxTextNumber: number = 99;

  static getNTFSingleItemCompId(scene: LiveUseScene, hasCode: string): string {
    return 'NTF_single_item_' + scene + '_' + hasCode;
  }

  static getLiveItemCompId(scene: LiveUseScene, hasCode: string): string {
    return 'live_item_content_' + scene + '_' + hasCode;
  }

  static getGroupBriefItemCompId(groupTypeKey: string): string {
    return 'NotificationGroupItem_GroupBrief_' + groupTypeKey;
  }

  static getGroupNTFItemCompId(groupTypeKey: string): string {
    return 'NotificationGroupDetail_' + groupTypeKey;
  }

  static isGroupNTF(entry: NotificationEntry): boolean {
    return Boolean(entry.groupEntry?.childrenEntry && entry.groupEntry.childrenEntry.length > 1);
  }

  /* 设备支持swing能力 */
  public static readonly CONFIG_SWING_ENABLE = 'const.config.swing_enabled';
  /* 隐藏横幅通知内容设置的key */
  public static readonly APP_NTF_CONFIG_HIDE_BANNER_CONTENT: string = 'app_ntf_config_hide_banner_content';
  /* 默认关闭隐藏横幅通知内容开关 等于1为默认开启*/
  public static readonly BANNER_NTF_HIDE_CONTENT: string = '0';

  /**
   * 智能分组开关
   */
  public static readonly UNIFIED_GROUP_ENABLE: string = 'unified_group_enable';

  /**
   * 聚合分组开关默认设置
   */
  public static readonly UNIFIED_GROUP_ENABLE_DEFAULT: boolean = true;
  /**
   * 滚动折叠通知高度阈值, 单位vp
   */
  public static readonly NTF_MAX_HEIGHT_THRESHOLD: number = 123;
  /**
   * 滚动折叠实况通知高度阈值, 单位vp
   */
  public static readonly LIVE_VIEW_MAX_HEIGHT_THRESHOLD: number = 250;
  /**
   * 通知标题id
   */
  public static readonly NTF_TITLE_ID: string = 'ntf_title_id_';
  /**
   * 通知内容id
   */
  public static readonly NTF_CONTENT_ID: string = 'ntf_content_id_';
  /**
   * 透明卡片高度
   */
  public static readonly TRANSPARENT_CARD_HEIGHT: number = 88;
  /**
   * 更多通知收起时更多卡片高度
   */
  public static readonly TRANSPARENT_CARD_HEIGHT_WHEN_COLLAPSED: number = 550;
  /**
   * 置顶标记ID
   */
  public static readonly NTF_PIN_TOP_ID: string = 'ntf_pin_top_id_';
  /**
   * 通知时间ID
   */
  public static readonly NTF_TIME_ID: string = 'ntf_time_id_';
  /**
   * 通知大图标ID
   */
  public static readonly NTF_BIG_ICON_ID: string = 'ntf_big_icon_id_';
  /**
   * 上半分区通知共享元素ID后缀
   */
  public static readonly NTF_MAIN_SUFFIX: string = '_main';
  /**
   * 下半分区通知共享元素ID后缀
   */
  public static readonly NTF_MORE_SUFFIX: string = '_more';
  /**
   * 左滑通知菜单的外边距top值
   */
  public static readonly NTF_MENU_ROW_MARGIN_TOP: number = 12;
  /**
   * 通知列表id
   */
  public static readonly NTF_LIST_CONTENT_ROW_ID: string = 'NotificationListContentRow_NtfCenter';
  /**
   * 通知内容列表id
   */
  public static readonly NTF_LIST_ROW_ID: string = 'NotificationListRow_NtfCenter';
  /**
   * 通知中心列表中更多通知折叠态组件ID
   */
  public static readonly NTF_CENTER_EXTRA_BRIEF_COMP_ID = 'NotificationListContent_ExtraContentBrief';
  /**
   * 通知中心列表中更多通知Header组件ID
   */
  public static readonly NTF_CENTER_EXTRA_HEADER_COMP_ID = 'NotificationExtraHeader_NtfCenter';
  /**
   * 通知中心列表中更多通知Header按钮组件ID
   */
  public static readonly NTF_CENTER_EXTRA_HEADER_BUTTON_COMP_ID = 'NotificationExtraHeaderButton_NtfCenter';
  /**
   * 通知中心列表中更多通知Header的标题组件ID
   */
  public static readonly NTF_CENTER_EXTRA_TITLE_COMP_ID = 'NotificationExtraHeader_Title_Extra_Ntf';
  /**
   * 通知中心列表中，组通知内子通知组件ID前缀
   */
  public static readonly NTF_CENTER_GROUP_SUB_COMP_ID_PREFIX = 'NotificationSingleItem';
  /**
   * 通知中心数据更新拦截器名
   */
  public static readonly UPDATE_DATA_INTERCEPTOR = 'update_data_interceptor';
  /**
   * 应用内通知管理linkFeature
   */
  public static readonly APP_NTF_MGMT = 'AppNotificationMgmt';
}

export enum SCBFoldState {
  UNKNOWN = 0,
  HALF_FOLDED_VIRTUAL_KEYBOARD,
  HALF_FOLDED_PHYSICAL_KEYBOARD,
  HALF_FOLDED,
  UNFOLDED_VERTICAL,
  UNFOLDED_HORIZONTAL
};

