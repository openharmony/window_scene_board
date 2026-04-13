/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import type ctx from '@ohos.app.ability.common';
import { image } from '@kit.ImageKit';
import systemparameter from '@ohos.systemParameterEnhance';
import { CustomContentDialog } from '@ohos.arkui.advanced.Dialog';
import { StyleConstants } from '../constants/StyleConstants';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  SingleContext
} from '@ohos/basicutils';
import {
  DeviceHelper,
  IconResourceManager,
  localEventManager,
  GlobalContext,
  onLineThemeUtil
} from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { LayoutViewModel } from '../viewmodel/LayoutViewModel';
import { CommonConstants, DeviceState, DeleteAction } from '../constants/CommonConstants';
import { AppItemInfo } from '../bean/AppItemInfo';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { StyleConfig } from './StyleConfig';
import { ReceiveEventInfo } from '../bean/ReceiveEventInfo';
import { AppModel } from '../TsIndex';
import { UninstallDialogTips, UninstallDialogUtil } from '../utils/UninstallDialogUtil';
import { EventConstants } from '../constants/EventConstants';
import { DialogController, DialogControllerType } from '../viewmodel/DialogController';
import { RTLUtil } from '@ohos/componenthelper';

const TAG = 'UninstallDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const APP_CLONE_BADGE_SIZE = 21;

@CustomDialog
export struct UninstallDialog {
  @StorageLink('uninstallAppInfo') appInfo?: AppItemInfo = undefined;
  @StorageLink('isPad') isPad: boolean = false;
  @StorageLink('NavigationBarStatusValue') navigationBarStatusValue: boolean = false;
  @StorageLink('showUninstallDialog') @Watch('showUninstallDialogChange') showUninstallDialog: boolean = false;
  @StorageLink('folderStatus') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  fromRemoveAction?: number = -1;
  controller?: CustomDialogController;
  cancel?: Function;
  confirm?: Function;
  dialogName: string | Resource = '';
  dialogContent: string | Resource = '';
  @State icon: image.PixelMap | ResourceStr | undefined = undefined;
  appIcon: string = '';
  bundleName: string = '';
  moduleName: string = '';
  appIndex: number = 0;
  mUninstallDialogWidth: string = '';
  isFromDesktop: boolean = false;
  isFromAppCenter: boolean = false;
  private mLayoutViewModel?: LayoutViewModel;
  isPC? : boolean = DeviceHelper.isPC();
  @State isDialogShow: boolean = false;
  @State mImageSize: number = 0;
  private isNewStyle: boolean = true;
  @State loadDialog: boolean = false;
  @State dialogOffsetY: Resource | string | number = 0;
  private scroller: Scroller = new Scroller();
  private isBusinessStyle?: boolean = false;
  private uninstallDialogTips: UninstallDialogTips = new UninstallDialogTips();
  @Prop singleContext?: SingleContext;

  private async updateScreenSize() {
    this.mUninstallDialogWidth = this.mLayoutViewModel?.getUninstallDialogWidth() as string;
    this.mImageSize = this.isPC ? StyleConstants.DEFAULT_APP_ITEM_HEIGHT :
      (StyleConstants.DEFAULT_APP_ITEM_HEIGHT + StyleConstants.DEFAULT_2);
  }

  private mDefaultAppIcon: string = '';

  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string) => {
      if (event === `updateIconImage_${this.bundleName}`) {
        this.updateIcon();
      }
    }
  };

  private readonly dialogOffsetChangeListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string) => {
      const dialogController = DialogController
        .getDialogController(this.isFromDesktop ? DialogControllerType.DESKTOP_APP : DialogControllerType.UNKNOWN);
      this.dialogOffsetY = dialogController?.getDialogOffsetY() ?? 0;
    }
  }

  private registerEvent(): void {
    let updateIconImageEvent: string = 'updateIconImage_' + this.bundleName;
    localEventManager.registerEventListener(this.mLocalEventListener, [updateIconImageEvent]);
    localEventManager.registerEventListener(this.dialogOffsetChangeListener,
      [EventConstants.EVENT_UPDATE_DIALOG_POSITION]);
  }

  public aboutToAppear(): void {
    log.showInfo('uninstall dialog aboutToAppear.');
    const dialogController = DialogController
      .getDialogController(this.isFromDesktop ? DialogControllerType.DESKTOP_APP : DialogControllerType.UNKNOWN);
    this.dialogOffsetY = dialogController?.getDialogOffsetY() ?? 0;
    AppStorage.setOrCreate('showUninstallDialog', true);
    this.registerEvent();
    this.mLayoutViewModel = LayoutViewModel.getInstance(this.singleContext);
    this.updateScreenSize();
    this.appIcon = String((this.appInfo as AppItemInfo).appIconId);
    this.bundleName = (this.appInfo as AppItemInfo).bundleName as string;
    this.moduleName = (this.appInfo as AppItemInfo).moduleName as string;
    this.appIndex = (this.appInfo as AppItemInfo).appIndex as number;
    this.isDialogShow = true;

    if (CheckEmptyUtils.isEmpty(this.icon)) {
      this.updateIcon();
    } else {
      this.isDialogShow = true;
    }
    this.isNewStyle = (systemparameter.getSync('sceneboard.isNewStyle', 'true') === 'true');
    this.getNeedTipsApp();
  }

  aboutToDisappear() {
    localEventManager.unregisterEventListener(this.mLocalEventListener);
    localEventManager.unregisterEventListener(this.dialogOffsetChangeListener);
  }

  public iconLoadCallback(image: string) {
    this.icon = image;
  }

  /**
   * 图标资源优先从内存缓存读取，读不到再从三级缓存获取
   */
  public updateIcon(): void {
    if (this.fromRemoveAction === DeleteAction.ACTION_REMOVE ||
      this.fromRemoveAction === DeleteAction.ACTION_UNINSTALL) {
      this.icon = this.appInfo?.iconResource as string;
      this.loadDialog = true;
      return;
    }
    this.icon = IconResourceManager.getInstance().getCachedCombIconSync(this.bundleName,
      this.moduleName, this.appInfo?.abilityName, this.appIndex);
    if (!CheckEmptyUtils.isEmpty(this.icon)) {
      log.showInfo('updateIcon done.');
      this.loadDialog = true;
      return;
    }

    this.updateIconAsync();
  }

  private async getNeedTipsApp(): Promise<void> {
    if (UninstallDialogUtil.checkIsNeedTipsApp(this.bundleName)) {
      let uninstallDialogTips = await UninstallDialogUtil.getResUninstallAppInfo(this.bundleName);
      this.uninstallDialogTips.title = uninstallDialogTips.title;
      this.uninstallDialogTips.content = uninstallDialogTips.content;
    }
    if (CheckEmptyUtils.isEmpty(this.uninstallDialogTips.title)) {
      this.uninstallDialogTips.title = this.getTitle();
    }
    if (CheckEmptyUtils.isEmpty(this.uninstallDialogTips.content)) {
      this.uninstallDialogTips.content = this.getContent();
    }
  }

  private async updateIconAsync() {
    try {
      let iconResource = await IconResourceManager.getInstance().getCombIcon(this.bundleName,
        this.moduleName, this.appInfo?.abilityName, this.appIndex, 'CombIcon_UninstallDialog');
      this.icon = CheckEmptyUtils.isEmpty(iconResource) ? this.mDefaultAppIcon : iconResource;
      log.showInfo('updateIconAsync icon done.');
    } catch (error) {
      log.error('initDialogIcon', error);
    } finally {
      this.loadDialog = true;
    }
  }

  private folderStatusChange(): void {
    if (this.isDialogShow) {
      log.showInfo(`UninstallDialog folderStatusChange: ${this.folderStatus}`);
      this.isDialogShow = false;
      this.controller?.close();
      this.cancel?.();
    }
  }

  private showUninstallDialogChange() {
    log.showInfo(`UninstallDialog showUninstallDialogChange showUninstallDialog: ${this.showUninstallDialog}`);
    if (!this.showUninstallDialog) {
      this.controller?.close();
      this.cancel?.()
    }
  }

  private getTitle(): string | Resource {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return this.dialogName;
    }
    if (AppModel.getInstance().getCloneAppNumber(this.bundleName) > 1) {
      return this.dialogName;
    }
    if (!this.isPC) {
      return this.dialogName;
    }
    return '';
  }

  private getContent(): string | Resource {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return this.dialogContent;
    }

    if (AppModel.getInstance().getCloneAppNumber(this.bundleName) > 1) {
      if (!this.appInfo?.appIndex) {
        return $r('app.string.delete_master_app_dialog_content');
      } else {
        return $r('app.string.delete_clone_app_dialog_content');
      }
    }

    if (!this.isPC) {
      return $r('app.string.delete_app_dialog_content');
    }

    return this.isPC && !this.isFromAppCenter ? $r('app.string.remove_app_dialog_content') : '';
  }

  @Builder
  DialogImageBuilder() {
    Image(this.icon)
      .width(this.mImageSize)
      .height(this.mImageSize)
      .draggable(false)
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
      .clip(true)
      .borderRadius(this.isPC ? StyleConstants.DEFAULT_18 : CommonConstants.DEFAULT_ICON_RADIUS)
  }

  @Builder
  DialogConfirmBuilder() {
    if (this.isPC) {
      Column() {
        Text(this.dialogName)
          .draggable(false)
          .id(`${TAG}_Text_dialogName`)
          .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
          .fontWeight(this.isBusinessStyle ? FontWeight.Bold : StyleConstants.DEFAULT_FORM_FONT_TITLE_WEIGHT)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(StyleConstants.DEFAULT_2)
      }
      .width(StyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
      .justifyContent(FlexAlign.Center)
      .margin({ top: StyleConstants.DEFAULT_17, bottom: StyleConstants.DEFAULT_4 })
      .padding({
        start: LengthMetrics.vp(StyleConstants.PADDING_LEFT),
        end: LengthMetrics.vp(StyleConstants.PADDING_RIGHT),
      })
    } else {
      Text(this.dialogName).draggable(false)
        .id(`${TAG}_Text_dialogName`)
        .fontSize($r('sys.float.ohos_id_text_size_button1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .lineHeight(StyleConstants.DEFAULT_APP_NAME_LINE_HEIGHT)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(StyleConstants.DEFAULT_APP_NAME_LINES)
        .margin({
          top: LengthMetrics.vp(StyleConstants.DEFAULT_DIALOG_TOP_MARGIN),
          bottom: LengthMetrics.vp(StyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN),
          end: LengthMetrics.vp(StyleConstants.DEFAULT_DIALOG_RIGHT_MARGIN),
          start: LengthMetrics.vp(StyleConstants.DEFAULT_DIALOG_LEFT_MARGIN)
        })
        .textAlign(TextAlign.Center)
    }
  }

  private getTipsContent(): string | Resource {
    if (this.isFromAppCenter) {
      return this.getContent();
    } else {
      return $r('app.string.remove_app_dialog_content');
    }
  }

  @Builder
  DialogTipsBuilder() {
    if (this.isPC) {
      Column() {
        Text(this.getTipsContent()).draggable(false)
          .id(`${TAG}_Text_removeFormDiglogContent`)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontWeight(StyleConstants.DEFAULT_FORM_FONT_CONTENT_WEIGHT)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }
      .width(StyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
      .justifyContent(FlexAlign.Center)
      .margin({
        top: StyleConstants.DEFAULT_4,
        bottom: StyleConstants.DEFAULT_18
      })
      .padding({ left: StyleConstants.PADDING_LEFT, right: StyleConstants.PADDING_RIGHT })
    }
  }

  @Builder
  DialogEmptyBuilder() {
    Column() {
    }
    .width(StyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
    .justifyContent(FlexAlign.Start)
    .margin({
      top: StyleConstants.DEFAULT_8
    })
    .padding({ left: StyleConstants.PADDING_LEFT, right: StyleConstants.PADDING_RIGHT })
  }

  @Builder
  DialogButtonBuilder() {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
      Button({ type: this.isBusinessStyle ? ButtonType.Normal : ButtonType.Capsule, stateEffect: true }) {
        Text($r('app.string.cancel')).draggable(false)
          .id(`${TAG}_Text_cancel`)
          .fontSize($r('sys.float.ohos_id_text_size_button1'))
          .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
          .padding({ top: this.isPC ? StyleConstants.DEFAULT_1 : StyleConstants.DEFAULT_0 })
      }
      .id(`${TAG}_Button_cancel`)
      .backgroundColor(StyleConfig.buttonStyle().backgroundColor)
      .height(StyleConfig.buttonStyle().height)
      .width(StyleConfig.buttonStyle().width)
      .borderRadius(this.isBusinessStyle ? StyleConstants.DEFAULT_8 : StyleConstants.PC_DIALOG_BUTTON_RADIUS)
      .onClick(() => {
        this.controller?.close();
        this.cancel?.()
      })
      .onKeyEvent((keyEvent?: KeyEvent) => {
        log.showInfo(`UninstallDialog onKeyEvent  keyCode: ${keyEvent?.keyCode}`);
        if (keyEvent?.keyCode === KeyCode.KEYCODE_ENTER) {
          this.controller?.close();
          this.cancel?.();
        }
      })

      if (StyleConfig.showDivider()) {
        Divider().vertical(true).height(StyleConstants.DEFAULT_DIVIDER_HEIGHT)
          .color($r('sys.color.ohos_id_color_list_separator'))
          .alignSelf(ItemAlign.Center)
      }

      Button({ type: this.isBusinessStyle ? ButtonType.Normal : ButtonType.Capsule, stateEffect: true }) {
        Text(this.getConfirmName())
          .draggable(false)
          .id(`${TAG}_Text_deleteOruninstall}`)
          .fontSize($r('sys.float.ohos_id_text_size_button1'))
          .fontColor($r('sys.color.ohos_id_color_warning'))
          .padding({ top : this.isPC ? StyleConstants.DEFAULT_1 : StyleConstants.DEFAULT_0 })
          .focusable(true)
      }
      .id(`${TAG}_Button_uninstallOrSubmit`)
      .backgroundColor(StyleConfig.buttonStyle().backgroundColor)
      .height(StyleConfig.buttonStyle().height)
      .width(StyleConfig.buttonStyle().width)
      .borderRadius(this.isBusinessStyle ? StyleConstants.DEFAULT_8 : StyleConstants.PC_DIALOG_BUTTON_RADIUS)
      .defaultFocus(true)
      .onFocus(() => {
        this.getUIContext()?.getFocusController()?.activate(true, false);
      })
      .focusBox({
        strokeWidth: LengthMetrics.vp(StyleConstants.DEFAULT_2),
        strokeColor: ColorMetrics.resourceColor($r('sys.color.interactive_focus')),
        margin: LengthMetrics.vp(StyleConstants.DEFAULT_2)
      })
      .onClick(() => {
        this.controller?.close();
        this.confirm?.()
      })
      .onKeyEvent((keyEvent?: KeyEvent) => {
        log.showInfo(`UninstallDialog onKeyEvent  keyCode: ${keyEvent?.keyCode}`);
        if (keyEvent?.keyCode === KeyCode.KEYCODE_ENTER) {
          this.controller?.close();
          this.confirm?.();
        }
      })
    }
  }

  private getConfirmName(): Resource {
    if (this.fromRemoveAction === DeleteAction.ACTION_REMOVE) {
      return $r('app.string.remove_button');
    } else if (this.isPad && this.isFromDesktop) {
      return $r('app.string.delete_app');
    } else if (this.appInfo?.appIndex) {
      return $r('app.string.delete');
    }
    return $r('app.string.uninstall');
  }

  private getUpdateTitle(): string | Resource {
    if (this.fromRemoveAction === DeleteAction.ACTION_REMOVE) {
      return this.dialogName;
    }
    return this.uninstallDialogTips.title;
  }

  @Builder
  appIconContentBuilder() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Image(this.icon)
          .width(this.mImageSize)
          .height(this.mImageSize)
          .draggable(false)
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false)
          .clip(true)
          .enabled(false)
          .borderRadius(onLineThemeUtil.isOnlineTheme() ? 0 : CommonConstants.DEFAULT_ICON_RADIUS)
        if (this.appIndex > 0) {
          Image($r(`app.media.app_icon_clone_index_${this.appIndex}`))
            .height(APP_CLONE_BADGE_SIZE)
            .width(APP_CLONE_BADGE_SIZE)
            .enabled(false)
            .offset({
              x: RTLUtil.isRTL() ? StyleConstants.DEFAULT_4 - this.mImageSize / 2 :
                this.mImageSize / 2 - StyleConstants.DEFAULT_4,
              y: this.mImageSize / 2 - StyleConstants.DEFAULT_8
            })
        }
      }
      Text(this.getUpdateTitle())
        .margin({
          top: StyleConstants.DEFAULT_16,
          bottom: StyleConstants.DEFAULT_16,
        })
        .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
        .maxFontScale(CommonConstants.AGING_FONT_SCALE)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
      Scroll(this.scroller) {
        Text(this.getUpdateContent())
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .maxFontScale(CommonConstants.AGING_FONT_SCALE)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Vertical)
      .constraintSize({ maxHeight: '30%' })
    }
    .width('100%')
  }

  private getUpdateContent(): string | Resource {
    if (this.fromRemoveAction === DeleteAction.ACTION_REMOVE) {
      return this.dialogContent;
    }
    return this.uninstallDialogTips.content;
  }

  @Builder
  platformTipsDialogs() {
    CustomContentDialog({
      contentBuilder: () => {
        this.appIconContentBuilder();
      },
      buttons: [
        {
          value: $r('app.string.cancel'),
          action: () => {
            this.controller?.close();
            this.cancel?.();
          }
        },
        {
          value: this.getConfirmName(),
          fontColor: $r('sys.color.ohos_id_color_warning'),
          action: () => {
            this.controller?.close();
            (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub
              .emit(`appUninstall${this.bundleName}`);
            this.confirm?.();
          }
        }
      ]
    })
  }

  @Builder
  customUninstallDialog() {
    Column() {
      this.DialogImageBuilder()
      this.DialogConfirmBuilder()
      if (this.isPC && this.isFromAppCenter && AppModel.getInstance().getCloneAppNumber(this.bundleName) === 1) {
        this.DialogEmptyBuilder()
      } else {
        this.DialogTipsBuilder()
      }
      this.DialogButtonBuilder()
    }
    .offset({ x: 0, y: this.dialogOffsetY })
    .backgroundBlurStyle(DeviceHelper.isPC() ? (this.isBusinessStyle ? BlurStyle.COMPONENT_ULTRA_THICK :
    BlurStyle.COMPONENT_REGULAR) : BlurStyle.Regular,
      { policy: 1 }, { disableSystemAdaptation: true })
    .shadow(ShadowStyle.OUTER_DEFAULT_LG)
    .margin({ left: StyleConstants.DEFAULT_16, right: StyleConstants.DEFAULT_16 })
    .padding({
      top: this.isPC ? StyleConstants.DEFAULT_25 : StyleConstants.DEFAULT_24,
      bottom: (this.isPC && this.isFromAppCenter) ? StyleConstants.DEFAULT_16 :
        this.isBusinessStyle ? StyleConstants.DEFAULT_16 : StyleConfig.rootContainerStyle().paddingBottom
    })
    .border({
      radius: $r('sys.float.ohos_id_corner_radius_dialog')
    })
    .width(StyleConfig.rootContainerStyle().width)
    .visibility(this.isDialogShow ? Visibility.Visible : Visibility.Hidden)
  }

  build() {
    if (this.isNewStyle && !this.isPC) {
      if (this.loadDialog) {
        this.platformTipsDialogs();
      }
    } else {
      this.customUninstallDialog();
    }
  }
}
