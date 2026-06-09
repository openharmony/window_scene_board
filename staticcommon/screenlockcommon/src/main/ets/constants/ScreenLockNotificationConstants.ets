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

export class ScreenLockNotificationConst {
  /**
   * eventManager通知 锁屏页面通知列表折叠为小图标
   */
  public static readonly SCREENLOCK_NTF_LIST_COLLAPSED: string = 'screenLockNtfListCollapsed';

  /**
   * eventManager通知 合一编辑器已经Ready
   */
  public static readonly THEME_EDITOR_READY_TO_SHOW: string = 'themeEditorReadyToShow';

  /**
   * eventManager通知 锁屏通知需要收起左滑
   */
  public static readonly SCREENLOCK_NTF_NEED_TO_SWIPE_TO_COLLAPSE: string = 'screenLockNtfSwipeToCollapse';

  /**
   * 锁屏点击通知提示框id
   */
  public static readonly NTF_KEY_GUARD_TIP: string = 'NTF_KEY_GUARD_TIP';

  /**
   * 锁屏外屏实况列表提示框id
   */
  public static readonly NTF_OUT_LIVE_LIST_KEY_GUARD_TIP: string = 'NTF_OUT_LIVE_LIST_KEY_GUARD_TIP';

  /**
   * 锁屏外屏临时横幅提示框id
   */
  public static readonly NTF_OUT_HEADS_UP_KEY_GUARD_TIP: string = 'NTF_OUT_HEADS_UP_KEY_GUARD_TIP';

  /**
   * 锁屏外屏通知中心提示框id
   */
  public static readonly NTF_OUT_DROPDOWN_PANEL_KEY_GUARD_TIP: string = 'NTF_OUT_DROPDOWN_PANEL_KEY_GUARD_TIP';

  /**
   * 锁屏点击通知提示框文本字串
   */
  public static readonly NTF_KEY_GUARD_CLICK_TIP: string = 'ntf_keyguard_click_tip';

  /**
   * 锁屏通知点击等待2s
   */
  public static readonly KEYGUARD_WAIT_DURATION: number = 2000;

  /**
   * 锁屏通知快速双击，第一次点击和第二次点击的时间间隔
   */
  public static readonly KEYGUARD_DOUBLE_CLICK_DURATION: number = 200;

  /**
   * 冻结通知更新事件
   */
  public static readonly FREEZE_NOTIFICATION_UPDATE: string = 'freezeNotificationUpdate';

  /**
   * 通知第一次点击
   */
  public static readonly NTF_FIRST_CLICK: number = 1;

  /**
   * 通知第二次点击
   */
  public static readonly NTF_SECOND_CLICK: number = 2;

  /**
   * 双击展开通知提示语
   */
  public static readonly DOUBLE_CLICK_EXPAND_TIP: string = 'kg_ntf_expand_tip';

  /**
   * 双击折叠通知提示语
   */
  public static readonly DOUBLE_CLICK_COLLAPSE_TIP: string = 'kg_ntf_collapse_tip';

  /**
   * 锁屏点击通知进入沉浸锁屏提示语
   */
  public static readonly IMMKG_NTF_CLICK_TIP: string = 'imm_kg_ntf_click_tip';

  /**
   * 双击跳转提示语
   */
  public static readonly KG_NTF_CLICK_TIP: string = 'kg_ntf_click_tip';

  /**
   * 单击通知弹窗显示持续时间
   */
  public static readonly CLICK_TOAST_SHOW_DURATION: number = 1500;

  /**
   * 通知没有详情提示语
   */
  public static readonly KG_NTF_NO_CONTENT_TIP: string = 'ntf_keyguard_no_content_click_tip';
}