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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { FormCenterViewStyle } from '../FormCenterViewStyle';
import { BaseStyleConfig } from './BaseStyleConfig';
import { FormCenterLocation } from './FormCenterEnum';
import { LengthMetrics } from '@kit.ArkUI';
import { FormCenterSplitViewStyle } from '../FormCenterSplitViewStyle';
import { AppListItemStyle } from '../AppListItemStyle';
import { ResUtils } from '@ohos/windowscene';
import { FormCenterStackViewStyle } from '../FormCenterStackViewStyle';
import { TileLayoutStyle } from '../TileLayoutStyle';
import { NavSwiperStyle } from '../NavSwiperStyle';
import { NavTileStyle } from '../NavTileStyle';
import { NavNoResultStyle } from '../NavNoResultStyle';
import { FormCenterViewModel } from '../../viewmodel/FormCenterViewModel';

export class FormCenterStyleConfig extends BaseStyleConfig<FormCenterViewStyle> {
  private static instance?: FormCenterStyleConfig;
  private constructor() {
    super();
    this.initStyle();
  }

  public static getInstance(): FormCenterStyleConfig {
    if (!FormCenterStyleConfig.instance) {
      FormCenterStyleConfig.instance = new FormCenterStyleConfig();
    }
    return FormCenterStyleConfig.instance;
  }

  public getStyle(): FormCenterViewStyle {
    let location: FormCenterLocation = FormCenterViewModel.getInstance().getFormCenterLocation();
    return super.getStyle(location) ?? new FormCenterViewStyle();
  }

  // 默认使用init方法进行初始化，如需本地定制，可以使用基类函数的setStyle方法
  private initStyle(): void {
    this.initDesktopStyle();
    this.initScreenLockStyle();
    this.initOuterStyle();
  }

  private initOuterStyle() {
    let outerStyle: FormCenterViewStyle = new FormCenterViewStyle();
    outerStyle.showClose = false;

    let stackStyle: FormCenterStackViewStyle = new FormCenterStackViewStyle();
    this.initStackTileLayoutStyle(stackStyle.tileLayoutStyle);
    outerStyle.stackViewStyle = stackStyle;
    stackStyle.searchComponentStyle.visibility = Visibility.Hidden;
    stackStyle.listPaddingTop = 0;
    stackStyle.listMarginTop = 0;
    stackStyle.getMarginTop = () => 0;
    stackStyle.isNeedSearch = true;
    stackStyle.tileLayoutStyle.formNameStyle.isNeedDescription = false;
    stackStyle.tileLayoutStyle.gridRowColumns = 4;
    stackStyle.noResultStyle.noResultImageLength = 120;
    stackStyle.noResultStyle.noResultColumnMargin = { top: 34 };
    this.setStyle(FormCenterLocation.OUTER, outerStyle);
  }

  private initScreenLockStyle(): void {
    let screenLockStyle: FormCenterViewStyle = new FormCenterViewStyle();
    screenLockStyle.maskColor = Color.Transparent;
    screenLockStyle.dragBar = true;
    screenLockStyle.getTitle = (): string => ResUtils.getInnerStringNumS($r('app.string.add_form_to_desktop'));

    let stackStyle: FormCenterStackViewStyle = new FormCenterStackViewStyle();
    this.initStackTileLayoutStyle(stackStyle.tileLayoutStyle);
    screenLockStyle.stackViewStyle = stackStyle;
    stackStyle.isNeedSearch = false;
    stackStyle.tileLayoutStyle.formNameStyle.isNeedDescription = false;
    stackStyle.tileLayoutStyle.gridRowColumns = 4;
    stackStyle.stackHeight = '100%';

    let splitStyle: FormCenterSplitViewStyle = new FormCenterSplitViewStyle();
    screenLockStyle.splitViewStyle = splitStyle;
    this.initSpiltAppListItemStyle(splitStyle.appListItemStyle);
    splitStyle.isNeedSearch = false;
    splitStyle.listMargin = { top: 0, };
    splitStyle.navHeight = `calc(100% - 8vp)`;

    splitStyle.swiperStyle = new NavSwiperStyle();
    splitStyle.swiperStyle.swiperLayoutStyle.buttonText = $r('app.string.add_to_screen_lock');

    splitStyle.tileStyle = new NavTileStyle();
    splitStyle.tileStyle.tileLayoutStyle.formNameStyle.isNeedDescription = false;
    splitStyle.tileStyle.tileLayoutStyle.gridRowColumns = 4;

    splitStyle.noResultStyle = new NavNoResultStyle();

    this.setStyle(FormCenterLocation.SCREEN_LOCK, screenLockStyle);
  }

  private initDesktopStyle(): void {
    let desktopStyle: FormCenterViewStyle = new FormCenterViewStyle();
    let splitStyle: FormCenterSplitViewStyle = new FormCenterSplitViewStyle();
    desktopStyle.splitViewStyle = splitStyle;
    this.initSpiltAppListItemStyle(splitStyle.appListItemStyle);

    splitStyle.swiperStyle = new NavSwiperStyle();
    splitStyle.tileStyle = new NavTileStyle();
    splitStyle.noResultStyle = new NavNoResultStyle();

    let stackStyle: FormCenterStackViewStyle = new FormCenterStackViewStyle();
    desktopStyle.stackViewStyle = stackStyle;
    this.initStackTileLayoutStyle(stackStyle.tileLayoutStyle);
    stackStyle.tileLayoutStyle.formNameStyle.appNameHeight = undefined;
    stackStyle.tileLayoutStyle.formNameStyle.appNameMargin = { top: 4, bottom: 2 };
    stackStyle.tileLayoutStyle.formNameStyle.descriptionHeight = undefined;
    stackStyle.tileLayoutStyle.formNameStyle.descriptionMargin = { bottom: 4 };
    this.setStyle(FormCenterLocation.DESKTOP, desktopStyle);
  }

  private initSpiltAppListItemStyle(style: AppListItemStyle): void {
    style.appSize = 36;
    style.isNeedArrow = false;
    style.itemHeight = 64;
    style.rowPadding = undefined;
    style.rowMargin = undefined;
    style.selectColor = $r('sys.color.ohos_id_color_click_effect');
    style.selectColorDark = $r('sys.color.ohos_id_color_click_effect_dark');

    style.appRadius = 8.23;
    style.appMargin = undefined;
    style.interpolation = ImageInterpolation.Medium;
    style.appMargin = {
      start: LengthMetrics.vp(12),
    };
    style.textFontSize = 16;
    style.maxLines = 1;
    style.textMargin = {
      start: LengthMetrics.vp(16),
    }
    style.lineHeight = 22;
  }

  private initStackTileLayoutStyle(tileLayoutStyle: TileLayoutStyle): void {
    tileLayoutStyle.formNameStyle.appNameFontSize = $r('sys.float.ohos_id_text_size_body2');
    tileLayoutStyle.formNameStyle.appNameFontWeight = FontWeight.Regular;
    tileLayoutStyle.formNameStyle.appNameHeight = 20;
    tileLayoutStyle.formNameStyle.appNameLineHeight = undefined;
    tileLayoutStyle.formNameStyle.appNameMargin = { top: 4, }

    tileLayoutStyle.formNameStyle.descriptionFontSize = $r('sys.float.ohos_id_text_size_body3');
    tileLayoutStyle.formNameStyle.descriptionHeight = 16;
    tileLayoutStyle.formNameStyle.descriptionMaxLines = 1;
    tileLayoutStyle.formNameStyle.descriptionLineHeight = undefined;
    tileLayoutStyle.formNameStyle.descriptionMargin = undefined;
  }
}