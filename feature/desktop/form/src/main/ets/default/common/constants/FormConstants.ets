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

/**
 * FormConstants
 *
 * @since 2023-02-13
 */
export default class FormConstants {
  /**
   * the bundle name of ai suggestion
   */
  public static readonly AI_SUGGESTION_BUNDLE_NAME = 'com.ohos.suggestion';

  /**
   * the bundle name of lite games suggestion
   */
  public static readonly LITE_GAMES_BUNDLE_NAME = 'com.ohos.litegames';

  /**
   * Threshold of newly installed apps in the service form pool
   */
  public static readonly SERVICE_FORM_POOL_NEW_INSTALL_APP_THRESHOLD = 5;

  /**
   * Threshold of newly updated apps in the service form pool
   */
  public static readonly SERVICE_FORM_POOL_UPDATE_APP_THRESHOLD = 5;

  /**
   * Threshold of big data apps in the service form pool
   */
  public static readonly SERVICE_FORM_POOL_BIG_DATA_THRESHOLD = 6;

  /**
   * Threshold of high frequency apps in the service form pool
   */
  public static readonly SERVICE_FORM_POOL_HIGH_FREQUENCY_APP_THRESHOLD = 8;

  /**
   * Threshold of ai suggestion in the service form pool
   */
  public static readonly SERVICE_FORM_POOL_AI_SUGGESTION_THRESHOLD = 1;

  /**
   * Threshold of lite games suggestion in the service form pool
   */
  public static readonly SERVICE_FORM_POOL_LITE_GAMES_SUGGESTION_THRESHOLD = 1;

  /**
   * Service form view : Number of fences - 4 for mobile phones
   */
  public static readonly SERVICE_FORM_VIEW_FENCE_COUNT_PHONE = 4;

  /**
   * Service form view : Number of fences - 6 for mobile phones
   */
  public static readonly SERVICE_FORM_VIEW_FENCE_COUNT_PHONE_INNER = 6;

  /**
   * Service form view : Number of small cards displayed in each row - 2 for mobile phones
   */
  public static readonly SERVICE_FORM_VIEW_SMALL_FORM_COUNT_EACH_ROW_PHONE = 2;

  /**
   * Service form view : Number of medium cards allowed in mobile phones
   */
  public static readonly SERVICE_FORM_VIEW_ALLOW_MEDIUM_FORM_COUNT_PHONE = 1;

  /**
   * Service form view : row of the RecommendCard in mobile phones
   */
  public static readonly SERVICE_FORM_VIEW_FORM_ROW_PHONE = 6;

  /**
   * Service form view : size of the small cards in mobile phones
   */
  public static readonly SMALL_SIZE_SERVICE_FORM = 2;

  /**
   * Service form view : size of the medium cards in mobile phones
   */
  public static readonly MEDIUM_SIZE_SERVICE_FORM = 3;

  /**
   * Service form view : size of the big cards in mobile phones
   */
  public static readonly LARGE_SIZE_SERVICE_FORM = 4;

  /**
   * 卡片管理打开于：服务卡片-宫格里面的form
   */
  public static readonly FORM_MANAGER_SHOW_FROM_FORM_SERVICE_GRID_FORM = 1;

  /**
   * 卡片管理打开于：服务卡片-app
   */
  public static readonly FORM_MANAGER_SHOW_FROM_FORM_SERVICE_FORM_APP = 2;

  /**
   * 卡片管理打开于：桌面form右键菜单（更多服务卡片）
   */
  public static readonly FORM_MANAGER_SHOW_FROM_DESKTOP_FORM_RIGHT_MENU = 3;

  /**
   * 卡片管理打开于：桌面app右键菜单（更多服务卡片）
   */
  public static readonly FORM_MANAGER_SHOW_FROM_DESKTOP_APP_RIGHT_MENU = 4;

  /**
   * 卡片管理打开于：上滑卡片（更多服务卡片）
   */
  public static readonly FORM_MANAGER_SHOW_FROM_SWIPER_UP_FORM_RIGHT_MENU = 5;

  /**
   * 卡片管理打开于：最近任务app右键菜单（更多服务卡片）
   */
  public static readonly FORM_MANAGER_SHOW_FROM_RECENT_APP_RIGHT_MENU = 6;

  /**
   * 卡片中心推荐卡片舆情卡片池阈值
   */
  public static readonly SERVICE_FORM_POOL_MEDIA_ENVIRONMENT_THRESHOLD = 6;

  /**
   * 卡片管理打开于：卡片中心搜索页面
   */
  public static readonly FORM_MANAGER_SHOW_FROM_SEARCH = 7;

  /**
   * 卡片管理打开于：元服务
   */
  public static readonly FORM_MANAGER_ATOMIC_SERVICE = 8;

  /**
   * 卡片管理打开于：应用
   */
  public static readonly FORM_MANAGER_APP = 9;

  /**
   * 服务卡片打开于：编辑模式
   */
  public static readonly FORM_SERVICE_SHOW_FROM_EDIT_MODE = 1;

  /**
   * 服务卡片打开于：从服务卡片界面的卡片打开到卡片管理以后的返回
   */
  public static readonly FORM_SERVICE_SHOW_FROM_GRID_FORM_BACK = 2;

  /**
   * 服务卡片打开于：从服务卡片界面的APP打开到卡片管理以后的返回
   */
  public static readonly FORM_SERVICE_SHOW_FROM_FORM_APP_BACK = 3;

  /**
   * 服务卡片打开于：桌面
   */
  public static readonly FORM_SERVICE_SHOW_FROM_DESKTOP = 4;

  /**
   * 卡片管理界面点击添加卡片至桌面
   */
  public static readonly EVENTHUB_FORM_MANAGER_CREATE_FORM = 'createFormToDesktop';

  /**
   * 卡片管理界面添加卡片至桌面返回结果
   */
  public static readonly EVENTHUB_FORM_MANAGER_CREATE_FORM_RESULT = 'createFormToDesktopResult';

  /**
   * 卡片管理界面被添加的卡片隐藏
   */
  public static readonly EVENTHUB_FORM_MANAGER_HIDE_FORM = 'formManagerHideForm';

  /**
   * 卡片管理界面拖拽撤销按钮热区改变
   */
  public static readonly EVENTHUB_FORM_MANAGER_UNDO_HOT_AREA = 'formManagerUndoHotArea';

  /**
   * 旋转后的卡片参数修改延迟，解决卡片截断的问题
   */
  public static readonly PORTRAIT_DELAY = 200;

  // 创建卡片雷达打点
  public static readonly FORM_MANAGER_CREATE_FORM = 'FORM_MANAGER_CREATE_FORM';

  // 编辑页面拉起卡片中心页面动效trace打点
  public static readonly EDIT_PAGE_TRACE_ENTER_FORM_CENTER = 'editPageEnterFormCenter';

  // 编辑页面退出卡片中心页面动效trace打点
  public static readonly EDIT_PAGE_TRACE_EXIT_FORM_CENTER = 'editPageExitFormCenter';

  // 没有搜索结果
  public static readonly NO_SEARCH_RESULT = 'noResult';

  // 关闭卡片中心键盘事件
  public static readonly CLOSE_KEYBOARD_OF_FORM_CENTER = 'closeKeyBoardOfFormCenter';

  // 重置搜索事件
  public static readonly RESET_SEARCH = 'resetSearch';

  // 卡片编辑页类型
  public static readonly FORM_EDIT_UI_EXTENSION_TYPE = 'formEdit';

  // 进入卡片编辑页trace打点
  public static readonly FORM_EDIT_VIEW_ENTER = 'FORM_EDIT_VIEW_ENTER';

  // 退出卡片编辑页trace打点
  public static readonly FORM_EDIT_VIEW_EXIT = 'FORM_EDIT_VIEW_EXIT';

  // 进卡片管理一镜到底动效新增1.6s截图渐隐动效 FormComponent渐显动效事件
  public static readonly FORM_MOTION_EVENT = 'form_motion_event';

  // 卡片编辑卡片显示
  public static readonly FORM_EDIT_SHOW = 'form_edit_show';
}