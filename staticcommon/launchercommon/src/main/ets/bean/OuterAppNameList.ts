/**
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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
 * 应用包名及描述
 *
 * @since 2025-1-18
 */
class AppCategorizeInfo {
  public bundleName: string = '';
  public description: string = '';
}

/**
 * 应用包名及描述
 *
 * @since 2025-1-18
 */
export class AppBundleInfo {
  public bundleName: string = '';
  public abilityNames: string[] = [];
}

/**
 * 应用对外屏是否适配
 *
 * @since 2025-1-18
 */
export class AppInfo {
  public bundleName: string = '';
  public abilityInfos: AbilityInfo[] = [];
  public appIsOuterSupport: boolean = false;
}

/**
 * ability对外屏是否适配
 *
 * @since 2025-1-18
 */
export class AbilityInfo {
  public abilityName: string = '';
  public appIsOuterSupport: boolean = false;
}

/**
 * 应用包名及描述
 *
 * @since 2025-1-18
 */
export class AppCategoryInfo {
  public bundleName: string = '';
  public category: number = -1;
}

/**
 * 新形态小折叠外屏应用名单列表
 *
 * @since 2025-1-18
 */
export class OuterAppNameListInfo {
  /**
   * 精选应用
   */
  public topQualityPkgList: AppCategorizeInfo[] = [];

  /**
   * 实验应用
   */
  public experimentalPkgList: AppCategorizeInfo[] = [];

  /**
   * 受信任卡片列表
   */
  public trustedCardPkg: AppCategorizeInfo[] = [];

  /**
   * 未适配外屏应用
   */
  public blocklistPkg: AppCategorizeInfo[] = [];

  /**
   * 禁止启动应用
   */
  public outerAppStartupAddIconBlocklist: AppCategorizeInfo[] = [];

  /**
   * 内外屏接续应用名单
   */
  public outerScreenFollowPkgList: AppCategorizeInfo[] = [];

  /**
   * 外屏显示shortcut应用名单
   */
  public outerShowShortcutMenusAppList: AppCategorizeInfo[] = [];
}