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

import Want from '@ohos.app.ability.Want';
import {
  ViewManager,
  editModeManager,
  FormCenterViewManager,
  DeviceState,
  StyleConstants,
  FormModel,
  EventConstants,
  CommonConstants,
  LayoutViewModel,
  FolderOperationFlag,
  DesktopManager,
  MultiSelectManager,
  NavBarHideAndShowManager,
  HiEditModeEventUtils,
  DesktopUtils,
  GridLayoutItemInfo,
  FolderManager,
} from '@ohos/launchercommon';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { DropAnimationCancelReason } from '@ohos/componentanimator';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';
import {
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  TextColor,
  ViewType,
  IconEditPageUtils,
  GlobalContext,
  WallpaperColorManager,
  viewMgrPolicy,
} from '@ohos/frameworkwrapper';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import EditModeStyleConstants, { EditModeDockConstants } from '../common/constants/EditModeStyleConstants';
import IconEditPageConstants from '../common/constants/IconEditPageConstants';
import { editModeViewManager } from '../manager/EditModeViewManager';
import { EditModeViewAnimate } from '../viewmodel/EditModeViewAnimate';
import { DesktopParam } from '@ohos/launchercommon/src/main/ets/bean/DesktopParam';
import lazy { OuterIconCenterViewManager } from '@ohos/launchercommon/src/main/ets/manager/OuterIconCenterViewManager';
import { ContractedFolderCommonViewModel, PageEditViewModel } from '@ohos/launchercommon/Index';
import { i18n } from '@kit.LocalizationKit';

const DARK_WALLPAPER_COLOR: string = 'FFFFFF';
const TAG: string = 'EditModeDockModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


/**
 * 编辑模式按钮Model
 */
export class EditModeDockViewModel {
  private desktopParam: DesktopParam = DesktopManager.getInstance().getDesktopParam();

  public isDarkWallpaper(): boolean {
    return this.desktopParam.darkWallpaper;
  }

  public updateFontColor(): void {
    let textColor: TextColor | undefined = launcherStatusUtil.getShowOutLauncherStatus() ?
    WallpaperColorManager.getInstance().mOuterTextColor : WallpaperColorManager.getInstance().mTextColor;
    if (textColor === undefined || textColor.mTextColor === undefined) {
      log.showError('textColor params error');
      return;
    }
    this.desktopParam.nameFontColor = textColor.mTextColor;
    // 如果文字颜色是#ffffff，说明是深色壁纸；如果是#000000，浅色壁纸
    this.desktopParam.darkWallpaper = textColor.mTextColor.toUpperCase().indexOf(DARK_WALLPAPER_COLOR) != -1
  }

  public editModeDockClick(key: string): void {
    if (editModeManager.isInNormalMode()) {
      // 退出编辑模式时、有延时和动画时间、这里要屏蔽点击事件
      return;
    }
    if (PageEditViewModel.getInstance().isDragingPage()) {
      log.showInfo(`editModeDockClick key:${key} can't click during dragging page`);
      // 拖拽页面时，屏蔽点击事件
      return;
    }
    const manager = MultiSelectManager.getInstance();
    if (manager.isInMultiSelect || manager.isInSingleDrag) {
      log.showInfo(`editModeDockClick key:${key} can't click during dragging `);
      return;
    }

    log.showInfo(`editModeDockClick key:${key} iconSize:%{public}d, data:%{public}s`, this.desktopParam.iconSize, JSON.stringify(this.desktopParam));
    const openedFolderItemInfo: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
    if (openedFolderItemInfo.folderId !== '-1') {
      ContractedFolderCommonViewModel.getInstance()
        .closeFolder('closeFolder by editModeDockIcon click', FolderOperationFlag.IMMEDIATELY);
    }
    HiEditModeEventUtils.reportEnterSubPage(key);
    if (key === EditModeDockConstants.FORM_SERVICE_KEY) {
      log.showInfo('open form page');
      GlobalContext.getContext()?.eventHub.emit('AiBarUseAppColor', true);
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.OPEN_FORM_CENTER);
      GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_MARK_DESKTOP_FREEZE, true);
      ViewManager.getInstance().jumpFormServiceView(FormConstants.FORM_SERVICE_SHOW_FROM_EDIT_MODE);
      return;
    }
    PageEditViewModel.getInstance().dragPageTipShowOrHideAnimate(0);
    if (key === EditModeDockConstants.WALLPAPER_KEY) {
      let want: Want = {
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'HomeThemeComponentExtAbility',
        parameters: {
          'ability.want.params.uiExtensionType': 'sys/commonUI',
          'nav': 'wallpaperPicker',
          'isFull': false,
          'desktopParam': DesktopManager.getInstance().updateExtendParam().getDesktopParam(),
          'statusBarHeight': viewMgrPolicy.getViewController(ViewType.STATUS_BAR)?.getArea()?.height ?? 0
        }
      };
      this.openEditModeExtensionUI(want);
      return;
    }
    if (key === EditModeDockConstants.ICON_KEY) {
      this.openIconEditPage(key);
      // 隐藏导航条
      NavBarHideAndShowManager.getInstance().executeCallbackByType(TAG, false);
      return;
    }
    if (key === EditModeDockConstants.THEME_KEY) {
      let want: Want = {
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'HomeThemeComponentExtAbility',
        parameters: {
          'ability.want.params.uiExtensionType': 'sys/commonUI',
          'nav': 'themeGallery',
          'isFull': true,
          'statusBarHeight': viewMgrPolicy.getViewController(ViewType.STATUS_BAR)?.getArea()?.height ?? 0,
          'source': 'desktopEdit',
        }
      };
      this.openEditModeExtensionUI(want);
      return;
    }
    if (key === EditModeDockConstants.OUTER_THEME_KEY) {
      log.showInfo('editModeDockClick key:%{public}s', key);
      let want: Want = {
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'CoverExtensionAbility',
        parameters: {
          'ability.want.params.uiExtensionType': 'sys/commonUI',
          'nav': 'subThemeGallery',
          'isFull': false,
          'source': 'desktopEdit',
        }
      };
      this.openEditModeExtensionUI(want);
      return;
    }
  }

  public getIconEditPageWant(key: string): Want {
    // 拿取want时，走一次get，调用其中的init方法刷新一次最新桌面参数，再更新一下文本颜色，以保证图标编辑页图标预览样式与桌面保持一致
    DesktopManager.getInstance().updateExtendParam().getDesktopParam();
    this.updateFontColor();
    return {
      bundleName: 'com.ohos.sceneboard',
      abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      parameters: {
        'nav': key,
        'ability.want.params.uiExtensionType': 'sys/commonUI',
        'desktopParam': this.desktopParam,
        'from': 'editModeButtonDock'
      }
    };
  }

  private openIconEditPage(key: string): void {
    let want: Want = this.getIconEditPageWant(key);
    let result: boolean = this.openEditModeExtensionUI(want);
    if (result) {
      HiEditModeEventUtils.startEnterIconEditPageTrack();
      new EditModeViewAnimate().playExtensionPage(true).finally(() => {
        HiEditModeEventUtils.endEnterIconEditPageTrack();
      });
      // 拉起UIExtension隐藏壁纸蒙版
      editModeManager.getEditModeWallpaperState().setShowWallpaperView(false);
      let desktopContext: ServiceExtensionContext = GlobalContext.getContext();
      desktopContext.eventHub.emit(EventConstants.EVENT_OPEN_ICON_EDIT_PAGE, true);
    }
  }
  /**
   * 预加载图标编辑UIExtension
   * @returns
   */
  public preloadIconEditPage(key: string): void {
    let want: Want = this.getIconEditPageWant(key);
    IconEditPageUtils.preloadIconEditPageExtAbility(getContext(),
      IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME, want.parameters);
  }

  /**
   * 图标预览区域的图标名称是否需要阴影
   * @returns
   */
  private isNeedAppNameShadow(): boolean {
    const isNewStyle = AppStorage.get<boolean>('desktopNewStyle') ?? true;
    const desktopTextShadow = AppStorage.get<boolean>('desktopTextShadow') ?? true;
    return isNewStyle && desktopTextShadow;
  }

  private openEditModeExtensionUI(want: Want): boolean {
    log.showInfo('openEditModeExtensionUI');
    editModeViewManager.getIconEditWantData().setExtensionWant(want);
    if (editModeViewManager.isShowUIExtension()) {
      log.showInfo('openEditModeExtensionUI is show return;');
      return false;
    }
    editModeViewManager.openUIExtension();
    return true;
  }

  /**
   * 退出服务卡片
   */
  public closeFormCenterView(): void {
    // 如果服务卡片打开了，退出编辑模式的同时退出服务卡片
    if (FormCenterViewManager.getInstance().isFormCenterViewShowing()) {
      FormCenterViewManager.getInstance().closeFormCenterView();
    }
  }

  /**
   * 根据产品获取底部按钮间距
   *
   * @returns 底部按钮间距
   */
  public getButtonDockSpace(): number {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      // 外屏编辑模式底部按钮间距
      let systemLang: string | undefined = i18n.System.getSystemLanguage();
      // 英文8vp
      if (systemLang === 'en-Latn-US') {
        return EditModeStyleConstants.OUTER_EDIT_BUTTON_ENGLISH_SPACE;
      }
      // 其余非简体12VP, 简体16vp
      if (systemLang && systemLang !== 'zh-Hans') {
         return EditModeStyleConstants.OUTER_EDIT_BUTTON_MINORITY_LANGUAGE_SPACE;
      }
    }
      return EditModeStyleConstants.EDIT_BUTTON_SPACE;
  }
}

export const editModeDockViewModel: EditModeDockViewModel = SingletonHelper.getInstance(EditModeDockViewModel, TAG);