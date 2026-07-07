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

import { dragController, LengthMetrics } from '@kit.ArkUI';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  ResourceManager,
  localEventManager,
  GlobalContext,
  HiSysEventUtil,
  IconResourceManager
} from '@ohos/frameworkwrapper';
import { DropAnimationScene } from '@ohos/componentanimator';
import { ObjectCopyUtil, dragSnapshotHelper, SnapshotType } from '@ohos/componenthelper';
import { ResUtils } from '@ohos/windowscene';
import { DragEventManager } from '@ohos/componentdrag';
import { DragConstants, } from '@ohos/commonconstants';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { MenuInfo } from '../bean/MenuInfo';
import { StyleConstants } from '../constants/StyleConstants';
import { AppStatus, CommonConstants } from '../constants/CommonConstants';
import { EventConstants } from '../constants/EventConstants';
import {
  AppItemInfo,
  RdbStoreManager,
  ShortcutViewModel,
  vibratorMgr,
  HiEditModeEventUtils,
  DeliverUtil
} from '../TsIndex';
import GridLayoutUtil from '../utils/GridLayoutUtil';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { MenuCommonUtil } from '../utils/MenuCommonUtil';
import { FontScaleManager } from '@ohos/frameworkwrapper/src/main/ets/fontscale/FontScaleManager';
import { FontScaleState } from '@ohos/frameworkwrapper/src/main/ets/fontscale/FontScaleState';
// import lazy { getOuterConstraintSizeOptions } from '../manager/OuterAppManager';
import { AppInstallUtils } from '../appinstall/AppInstallUtils';

const TAG = 'AppMenu';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);
const SHORTCUT_ICON_SIZE = 41;
const SHORTCUT_MENU_ICON_SIZE = 32;
const SHORTCUT_MENU_DARK_BG = '#0d000001';
const SHORTCUT_MENU_BASE_BG = '#1affffff';
const LONG_PRESS_TIME_FOR_MENU_DRAG = 500;
const CLOSE_MENU_DELAY_TIME = 150;

@Component
export struct AppMenu {
  @Prop menuInfoList: Array<MenuInfo> = [];
  @State fixedMenuList: Array<MenuInfo> = [];
  @State dynamicMenuList: Array<MenuInfo> = [];
  isBothTypeMenuExist: boolean = true;
  @Prop menuPlacement: Placement = Placement.BottomLeft;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  closeMenu: Function = () => {
  };
  private isPc: boolean = DeviceHelper.isPC();
  menuWidth: number = !this.isPc ?
    StyleConstants.APP_MENU_WIDTH_COLUMNS_PHONE : vp2px(AppStorage.get<number>('screenWidth') as number) / 10;
  appParams?: Map<string, Object>;
  mixedMenuList: MenuInfo[] = [];
  currentSelectItemLength: boolean = false;
  private iconSize: number = 0;
  private iconRadius: number = 0;
  private dragStart?: Function;
  private appItem?: GridLayoutItemInfo;
  private isBusinessStyle: boolean = false;
  private fontScaleState: FontScaleState = FontScaleManager.getInstance().getSysFontScaleState();
  private isOuterDesktop: boolean = false;
  private maxDynamicMenuHeight: number = Infinity;
  private keepMenuOrder: boolean = false;

  aboutToAppear() {
    this.fixedMenuList = new Array<MenuInfo>();
    this.dynamicMenuList = new Array<MenuInfo>();
    this.onMenuInfoListChange();
    AppStorage.setOrCreate('isLongPress', true);
    if (DeviceHelper.isPC()) {
      AppStorage.setOrCreate<boolean>('contextMenuState', true);
      log.showInfo(`currentSelectItemLength: ${this.currentSelectItemLength}`);
    }
  }

  private onMenuInfoListChange() {
    if (this.currentSelectItemLength) {
      for (let menuInfo of this.mixedMenuList) {
        this.fixedMenuList.push(menuInfo);
      }
    } else {
      this.addPreDownloadMenu();
      for (let menuInfo of this.menuInfoList) {
        if (menuInfo.menuType === CommonConstants.MENU_TYPE_FIXED) {
          if (this.appItem && this.appItem.typeId === CommonConstants.TYPE_APP &&
            !GridLayoutUtil.isAppInstalled(this.appItem) && DeliverUtil.isHideDhRemoveMenu(this.appItem.bundleName) &&
            menuInfo.menuImgSrc === '/common/pics/ic_public_remove.svg') {
            log.showWarn('download deliver and custom folder exist , can not remove');
            continue;
          }
          this.fixedMenuList.push(menuInfo);
        } else {
          this.dynamicMenuList.push(menuInfo);
        }
      }
    }
    this.isBothTypeMenuExist = this.fixedMenuList.length > 0 && this.dynamicMenuList.length > 0;
    AppStorage.setOrCreate('isLongPress', true);
    log.showInfo(`bundleName:${this.appItem?.bundleName}, fixedMenuLength:${this.fixedMenuList.length}, dynamicMenuLength:${this.dynamicMenuList.length}`);
  }

  private addPreDownloadMenu(): void {
    if (this.appItem?.typeId === 0 && AppInstallUtils.getInstance().isAddPreDownloadMenu(this.appItem)) {
      this.fixedMenuList.push(this.getPreDownloadInfo(this.appItem));
    }
  }

  private getPreDownloadInfo(appItem: GridLayoutItemInfo): MenuInfo {
    let menuInfo: MenuInfo = new MenuInfo();
    menuInfo.menuType = CommonConstants.MENU_TYPE_FIXED;
    menuInfo.menuImgSrc = '/common/pics/ic_public_download.svg';
    menuInfo.menuText = ResourceManager.getInstance().getStringByName('preferential_download');
    menuInfo.onMenuClick = (): void => {
      AppInstallUtils.getInstance().clickAppToPreDownload(appItem);
    };
    return menuInfo;
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear start');
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_APP_MENU_DISAPPEAR);
    this.fixedMenuList = [];
    this.dynamicMenuList = [];
    if (DeviceHelper.isPC()) {
      AppStorage.setOrCreate<boolean>('contextMenuState', false);
    }
  }

  private getAppMenuWidth(): Length {
    return (this.isBusinessStyle ?
      Math.ceil(vp2px(this.menuWidth * this.fontScaleState.getFontScale() - 2 * StyleConstants.DEFAULT_4)) + 'px' :
      this.menuWidth - 2 * StyleConstants.DEFAULT_4);
  }

  private reportClickShortcut(item: MenuInfo): void {
    if (item.shortcutId) {
      HiSysEventUtil.reportClickShortcut(item.bundleName, item.shortcutId, 'deepShortcut', '-1',
        '-1', '-1', '-1');
    }
  }

  private getAccessibilityDescription(isDynamicMenu: boolean): string {
    let executeText: string = ResourceManager.getInstance().getStringByName('double_tap_to_execute');
    if (!isDynamicMenu) {
      return executeText;
    }
    let dragText: string = ResUtils.getInnerString($r('app.string.accessibility_str_long_click_to_drag'));
    if (CheckEmptyUtils.checkStrIsEmpty(dragText)) {
      return executeText;
    }
    return `${executeText}, ${dragText}`;
  }

  @Builder
  dividerBuild(isShow :boolean, isInFixedMenuList: boolean = false) {
    if (isShow) {
      Divider()
        .vertical(false)
        .color($r('sys.color.ohos_id_color_list_separator'))
        .strokeWidth(px2vp(1))
        .margin({
          start: LengthMetrics.vp(StyleConstants.DEFAULT_12),
          end: LengthMetrics.vp(StyleConstants.DEFAULT_12),
          top: LengthMetrics.vp(isInFixedMenuList ? StyleConstants.DEFAULT_2 : StyleConstants.MENU_MARGIN),
          bottom: LengthMetrics.vp(isInFixedMenuList ? StyleConstants.DEFAULT_2 : StyleConstants.MENU_MARGIN),
        })
    }
  }

  @Builder
  pcMenuBuild() {
    Column() {
      Column({space: this.isBusinessStyle ? Math.ceil(vp2px(StyleConstants.DEFAULT_2)) + 'px' : StyleConstants.DEFAULT_1}) {
        ForEach(this.fixedMenuList, (item: MenuInfo, index?: number) => {
          this.dividerBuild(index === 1, true);
          this.pcMenuItemBuild(item, index, false);
        }, (item: MenuInfo) => JSON.stringify(item))
      }
      .visibility(this.fixedMenuList.length > 0 ? Visibility.Visible : Visibility.None)

      this.dividerBuild(this.isBothTypeMenuExist);

      Column({space: this.isBusinessStyle ? Math.ceil(vp2px(StyleConstants.DEFAULT_2)) + 'px' : StyleConstants.DEFAULT_1}) {
        ForEach(this.dynamicMenuList, (item: MenuInfo, index?: number) => {
          this.pcMenuItemBuild(item, index, true);
        }, (item: MenuInfo) => JSON.stringify(item))
      }
      .visibility(this.dynamicMenuList.length > 0 ? Visibility.Visible : Visibility.None)
    }
    .width(this.getAppMenuWidth())
  }

  @Builder
  pcMenuItemBuild(item: MenuInfo, index?: number, isDynamicMenu?: boolean) {
    MenuItem() {
      HorizontalMenuItem({
        menuInfo: item,
        closeMenu: this.closeMenu,
        menuWidth: this.getAppMenuWidth(),
        appParams: this.appParams,
        isMultiSelect: this.currentSelectItemLength,
        isNeedIcon: false,
        isBusinessStyle: this.isBusinessStyle
      })
    }
    .onClick((event: ClickEvent) => {
      if (!this.appParams) {
        this.appParams = new Map<string, Object>();
      }
      this.appParams.set('clickEvent', event);
      item?.onMenuClick?.(this.appParams);
      this.closeMenu();
      ContextMenu.close();
      localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
    })
    .id(isDynamicMenu ? `${TAG}_HorizontalMenuItem_dynamicMenu${index}` :
      `${TAG}_HorizontalMenuItem_fixedMenu${index}`)
  }

  @Builder
  phoneMenuItemBuild(menuList: MenuInfo[], width: number, isDynamicMenu: boolean, isMarginBottom: boolean,
    appItem?: GridLayoutItemInfo, iconSize: number = 0, iconRadius: number = 0, dragStart?: Function) {
    this.phoneMenuItem(menuList, isDynamicMenu, isMarginBottom, iconSize, iconRadius, dragStart, appItem);
  }

  @Builder
  phoneMenuBuild() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center}) {
      if (MenuCommonUtil.isShowBottom(this.menuPlacement)) {
        // Menu组件Scroll包装后有透明背板，arkui菜单建议新增不可见Menu，去除此背板，后续arkui优化
        Menu() {
        }
        .visibility(Visibility.None)
        Scroll() {
          this.phoneMenuItemBuild(this.dynamicMenuList, this.menuWidth, true, false,
            this.appItem, this.iconSize, this.iconRadius, this.dragStart);
        }
        .visibility(this.dynamicMenuList.length > 0 ? Visibility.Visible : Visibility.None)
        .borderRadius(StyleConstants.MENU_EXTERNAL_RADIUS)
        .constraintSize({ maxHeight: this.maxDynamicMenuHeight })
        .margin({bottom: StyleConstants.DEFAULT_8})

        // 固定菜单
        this.phoneMenuItemBuild(this.fixedMenuList, this.menuWidth, false, false, this.appItem);
      } else {
        // 固定菜单
        this.phoneMenuItemBuild(this.keepMenuOrder ? this.fixedMenuList : this.fixedMenuList.reverse(), this.menuWidth,
          false, this.dynamicMenuList.length > 0, this.appItem);
        // 快捷菜单
        Scroll() {
          this.phoneMenuItemBuild(this.dynamicMenuList.reverse(), this.menuWidth, true, false, this.appItem,
            this.iconSize, this.iconRadius, this.dragStart);
        }
        .visibility(this.dynamicMenuList.length > 0 ? Visibility.Visible : Visibility.None)
        .constraintSize({ maxHeight: this.maxDynamicMenuHeight })
        .borderRadius(StyleConstants.MENU_EXTERNAL_RADIUS)
        .initialOffset({ yOffset: '200%' })
      }
    }
    .width(this.menuWidth)
  }

  @Builder
  outerDesktopMenuBuild() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center}) {
      if (MenuCommonUtil.isShowBottom(this.menuPlacement)) {
        // Menu组件Scroll包装后有透明背板，arkui菜单建议新增不可见Menu，去除此背板，后续arkui优化
        Menu() {
        }
        .visibility(Visibility.None)
        // 快捷菜单
        Scroll() {
          this.phoneMenuItemBuild(this.dynamicMenuList, this.menuWidth, true, false,
            this.appItem, this.iconSize, this.iconRadius, this.dragStart);
        }
        .visibility(this.dynamicMenuList.length > 0 ? Visibility.Visible : Visibility.None)
        .borderRadius(StyleConstants.MENU_EXTERNAL_RADIUS)
        // .constraintSize(getOuterConstraintSizeOptions(this.appItem))
        .margin({ bottom: this.dynamicMenuList.length > 0 ? StyleConstants.DEFAULT_8 : StyleConstants.DEFAULT_0 })
        // 固定菜单
        this.phoneMenuItemBuild(this.fixedMenuList, this.menuWidth, false, false, this.appItem);
      } else {
        // 固定菜单
        this.phoneMenuItemBuild(this.fixedMenuList.reverse(), this.menuWidth, false, this.dynamicMenuList.length > 0,
          this.appItem);
        // 快捷菜单
        Scroll() {
          this.phoneMenuItemBuild(this.dynamicMenuList.reverse(), this.menuWidth, true, false, this.appItem,
            this.iconSize, this.iconRadius, this.dragStart);
        }
        .initialOffset({ yOffset: '200%' })
        .visibility(this.dynamicMenuList.length > 0 ? Visibility.Visible : Visibility.None)
        .borderRadius(StyleConstants.MENU_EXTERNAL_RADIUS)
        // .constraintSize(getOuterConstraintSizeOptions(this.appItem))
      }
    }
    .width(this.menuWidth)
  }

  @Builder
  phoneMenuItem(menuList: MenuInfo[], isDynamicMenu: boolean, isMarginBottom: boolean,
    iconSize: number = 0, iconRadius: number = 0, dragStart?: Function, appItem?: GridLayoutItemInfo) {
    Menu() {
      ForEach(menuList, (item: MenuInfo, index?: number) => {
        MenuItem() {
          Column() {
            HorizontalMenuItem({
              menuInfo: item,
              closeMenu: this.closeMenu,
              menuWidth: this.getAppMenuWidth(),
              appParams: this.appParams,
              isDynamicMenu: isDynamicMenu,
              iconSize: iconSize,
              iconRadius: iconRadius,
              dragStart: dragStart,
              appItem: appItem,
            }).id(`${TAG}_HorizontalMenuItem_${isDynamicMenu ? 'dynamicMenu' : 'fixedMenu'}${index}`)

            if (index !== menuList.length - 1) {
              Divider()
                .color($r('sys.color.ohos_id_color_list_separator'))
                .strokeWidth(px2vp(1))
                .margin({
                  start: LengthMetrics.vp(StyleConstants.DEFAULT_44 + StyleConstants.DEFAULT_2),
                  end: LengthMetrics.vp(StyleConstants.DEFAULT_12),
                })
            }
          }
          .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
        }
        .onClick(() => {
          item?.onMenuClick?.(this.appParams);
          this.reportClickShortcut(item);
          this.closeMenu();
          ContextMenu.close();
          localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
        })
        .accessibilityLevel(this.isAccessibilityMode ? 'yes' : 'no')
        .accessibilityDescription(this.isAccessibilityMode ? this.getAccessibilityDescription(isDynamicMenu) : '')
      }, (item: MenuInfo) => JSON.stringify(item))
    }
    .margin({bottom: isMarginBottom ? StyleConstants.DEFAULT_8 : StyleConstants.DEFAULT_0})
    .visibility(menuList.length > 0 ? Visibility.Visible : Visibility.None)
    .padding(StyleConstants.DEFAULT_4)
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, undefined, { disableSystemAdaptation: true })
    .width('100%')
    .borderRadius(StyleConstants.MENU_EXTERNAL_RADIUS)
  }

  build() {
    if (this.isPc) {
      this.pcMenuBuild()
    } else if (this.isOuterDesktop) {
      this.outerDesktopMenuBuild()
    } else {
      this.phoneMenuBuild()
    }
  }
}

@Component
struct HorizontalMenuItem {
  @State shortcutIcon: string = StyleConstants.DEFAULT_ICON;
  @State shortcutName: string = '';
  @State hoverState: boolean = false;
  @State pressState: boolean = false;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  closeMenu: Function = () => {
  };
  private mResourceManager: ResourceManager = ResourceManager.getInstance();
  private isPc = DeviceHelper.isPC();
  private isHYM = DeviceHelper.isHYM();
  private isQXSPcMode = DeviceHelper.is2In1DevicePcType();
  menuInfo: MenuInfo = new MenuInfo();
  menuWidth: Length = 0;
  imageFillColor: ResourceColor = !this.isPc ? $r('sys.color.ohos_id_color_secondary') : $r('sys.color.ohos_id_color_primary');
  appParams?: Map<string, Object>;
  edgeAntialias: number = 0;
  isNeedIcon: boolean = true;
  isDynamicMenu: boolean = false;
  isMultiSelect: boolean = false;
  private iconSize: number = 0;
  private iconRadius: number = 0;
  private dragStart?: Function;
  private appItem?: GridLayoutItemInfo;
  private menuItem?: GridLayoutItemInfo;
  private menuKey: string = '';
  private isBusinessStyle: boolean = false;

  public aboutToAppear(): void {
    // PC的菜单无图标, 不用updateIcon
    if (!this.isPc) {
      this.updateIcon();
    }
    this.updateName();
    if (this.isHYM) {
      this.edgeAntialias = 0.5;
    }
  }

  public shortcutIconLoadCallback(image: string) {
    this.shortcutIcon = image;
  }

  public shortcutNameLoadCallback(name: string) {
    this.shortcutName = name;
  }

  private getAppMenuItemHeight(): Length {
    if (this.isQXSPcMode) {
      return StyleConstants.DEFAULT_48;
    }
    return this.isBusinessStyle ? Math.floor(vp2px(40)) + 'px' : StyleConstants.DEFAULT_40
  }

  public updateIcon() {
    if (this.menuInfo.shortcutIconId != -1 && this.menuInfo.menuImgSrc != '' && this.menuInfo.menuImgSrc != null) {
      log.showInfo(`updateIcon shortcutId: ${this.menuInfo.shortcutId}, iconId: ${this.menuInfo.shortcutIconId}`);
      this.mResourceManager.getAppIconWithCache(
        this.menuInfo.shortcutIconId,
        this.menuInfo.bundleName as string,
        this.menuInfo.moduleName as string,
        (image: string): void => this.shortcutIconLoadCallback(image),
        StyleConstants.DEFAULT_ICON, 0,
      );
    } else {
      this.shortcutIconLoadCallback(this.menuInfo.menuImgSrc as string);
    }
  }

  public updateName() {
    if (this.menuInfo.shortcutLabelId != -1 && this.menuInfo.menuText != '' && this.menuInfo.menuText != null) {
      log.showInfo(`updateName shortcutId: ${this.menuInfo.shortcutId}, labelId: ${this.menuInfo.shortcutLabelId}`);
      IconResourceManager.getInstance().getAppNameWithCallback(this.menuInfo.shortcutLabelId, this.menuInfo.bundleName,
        this.menuInfo.moduleName, this.shortcutName, (name: string): void => this.shortcutNameLoadCallback(name));
    } else {
      this.shortcutNameLoadCallback(this.menuInfo.menuText as string);
    }
  }

  getItemBackgroundColor() {
    if (this.hoverState) {
      return $r('sys.color.ohos_id_color_hover');
    }
    if (this.pressState) {
      return $r('sys.color.ohos_id_color_click_effect');
    }
    return StyleConstants.DEFAULT_TRANSPARENT_COLOR;
  }

  getTextFontColor() : ResourceColor | string {
    if (this.currColorMode === 1) {
      return $r('sys.color.ohos_id_color_text_primary');
    } else {
      return $r('app.color.menu_text_color_dark');
    }
  }

  getImageBackgroundColor() : string {
    if (this.currColorMode === 1) {
      log.showInfo(`isDynamicMenu: ${this.isDynamicMenu} currColorMode: ${this.currColorMode}`);
      return SHORTCUT_MENU_DARK_BG;
    } else {
      log.showInfo(`isDynamicMenu: ${this.isDynamicMenu} currColorMode: ${this.currColorMode}`);
      return SHORTCUT_MENU_BASE_BG;
    }
  }

  private canMenuDrag(): boolean {
    return this.isDynamicMenu && this.dragStart != null;
  }

  private prepareForMenuDrag(): void {
    this.menuItem = new GridLayoutItemInfo();
    try {
      ObjectCopyUtil.deepClone(this.appItem, this.menuItem);
    } catch (error) {
      log.showInfo(`deepClone error: ${error}`);
      if (this.appItem) {
        this.menuItem = GridLayoutUtil.buildGridLayoutInfoFromItemInfo(this.appItem,
          this.appItem?.page ?? -1, this.appItem?.column ?? 0, this.appItem?.row ?? 0);
      }
    }
    this.menuItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
    this.menuItem.appIconId = this.menuInfo.shortcutIconId;
    this.menuItem.appLabelId = this.menuInfo.shortcutLabelId;
    this.menuItem.shortcutId = this.menuInfo.shortcutId;
    this.menuItem.isUninstallAble = true;
    this.menuItem.appName = this.shortcutName;
    this.menuItem.area = [1, 1];
    this.menuItem.downloadProgress = 0;
    this.menuItem.intent = '{"sourceType": "1"}';
    this.menuItem.keyName = AppItemInfo.getKeyName(this.menuItem);
    this.menuItem.infoId = RdbStoreManager.getInstance().generateRandomUUID();
    (this.menuItem as Object as AppItemInfo).appId = this.menuItem.infoId;
    ShortcutViewModel.getInstance().processShortcut(this.menuItem);
    this.menuKey = GridLayoutUtil.generateUniqueKey(this.menuItem);
    // 该截图用于快捷菜单图标拖拽落位时执行落位动效
    dragSnapshotHelper.snapshotFromBuilder(() => this.MenuDragImage(), SnapshotType.DROP, this.menuKey);
  }

  private menuDragStart(): void {
    AppStorage.setOrCreate<boolean>('isDrag', true);
    AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_SHORTCUT);
    log.showInfo('start to drag menu. id:%{public}s name:%{public}s', this.menuInfo.shortcutId, this.shortcutName);
    AppStorage.setOrCreate<GridLayoutItemInfo>('dragItemInfo', this.menuItem);
    HiEditModeEventUtils.reportDragShortcutToDeskTop(this.menuInfo.shortcutId ?? '', this.menuInfo.bundleName ?? '',
      this.menuInfo.moduleName ?? '');
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, this.menuKey)
      ?.setWidth(this.iconSize)
      .setHeight(this.iconSize)
      .setRadius(this.iconRadius);
  }

  private triggerMenuDrag(pointerId: number): void {
    dragController.executeDrag(() => this.MenuDragImage(), {
      pointerId: pointerId,
      touchPoint: { x: '50%', y: '50%' },
      previewOptions: { mode: DragPreviewMode.DISABLE_SCALE },
    }, (err, value) => {
      if (err) {
        log.error(`drag menu error `, err);
      } else {
        log.showInfo(`drag menu success`);
      }
      AppStorage.setOrCreate<boolean>('isDrag', false);
      AppStorage.setOrCreate<Object>('dragItemInfo', {});
      DragEventManager.getInstance().startDrop(this.menuKey);
    });
  }

  @Builder
  MenuDragImage() {
    Image(this.shortcutIcon)
      .height(this.iconSize * DragConstants.DROP_START_SCALE)
      .width(this.iconSize * DragConstants.DROP_START_SCALE)
      .borderRadius(this.iconRadius * DragConstants.DROP_START_SCALE)
      .syncLoad(true)
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
      .backgroundImage(ShortcutViewModel.getInstance()
        .getShortcutBackgroundImage({typeId: CommonConstants.TYPE_SHORTCUT_ICON,
          bundleName: this.appItem?.bundleName ?? ''}))
      .backgroundImageSize(ImageSize.Cover)
      .backgroundImagePosition(Alignment.Center)
  }

  @Styles
  menuDragStyle() {
    .gesture(GestureGroup(GestureMode.Parallel,
      LongPressGesture({ repeat: false, duration: CommonConstants.LONG_PRESS_TIME_FOR_SNAPSHOT })
        .onAction(() => {
          if (this.canMenuDrag()) {
            this.prepareForMenuDrag();
          }
        }),
      LongPressGesture({ repeat: false, duration: LONG_PRESS_TIME_FOR_MENU_DRAG })
        .onAction((event: GestureEvent) => {
          if (!this.canMenuDrag()) {
            log.showInfo(`menu cannot drag. isDynamicMenu:${this.isDynamicMenu} hasDragStart:${this.dragStart != null}`);
            return;
          }
          if (event.fingerList.length !== 1) {
            log.showError(`invalid gesture event. length:${event.fingerList.length}`);
            return;
          }
          const fingerInfo: FingerInfo = event.fingerList[0];
          let pointerId: number = fingerInfo.id;
          if (event.source === SourceType.Mouse) {
            pointerId = 0;
          }
          try {
            this.triggerMenuDrag(pointerId);
            this.menuDragStart();
            this.dragStart?.(fingerInfo.globalX, fingerInfo.globalY);
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_LONG_PRESS,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
            // 若菜单关闭后才触发拖拽，会导致多模事件分发异常，拖拽事件无法继续下发，故延迟关闭菜单规避此问题
            setTimeout(() => {
              // 调用父组件的closeMenu方法刷新父组件的isMenuShow可避免父组件刷新时bindContextMenu组件二次显示
              this.closeMenu();
              ContextMenu.close();
            }, CLOSE_MENU_DELAY_TIME);
          } catch (err) {
            log.error('drag menu error ', err);
          }
        })
    ))
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center
    }) {
      if (this.isDynamicMenu && this.shortcutIcon) {
        Stack() {
          Image(this.shortcutIcon)
            .draggable(false)
            .height(SHORTCUT_ICON_SIZE)
            .width(SHORTCUT_ICON_SIZE)
            .interpolation(ImageInterpolation.Medium)
            .autoResize(false)
            .backgroundColor(this.isPc ? Color.Transparent : this.getImageBackgroundColor())
            .id(`${TAG}_Image_shortCut`)
        }
        .height(SHORTCUT_MENU_ICON_SIZE)
        .width(SHORTCUT_MENU_ICON_SIZE)
        .borderRadius(SHORTCUT_MENU_ICON_SIZE / 2)
        .flexShrink(0)
        .margin({
          start: !this.isPc ? LengthMetrics.vp(StyleConstants.DEFAULT_6) : LengthMetrics.vp(StyleConstants.DEFAULT_12),
          end: LengthMetrics.vp(StyleConstants.DEFAULT_6),
        })
        .clip(true)
      } else if (!this.isMultiSelect && this.isNeedIcon) {
        Image(this.shortcutIcon).draggable(false)
          .id(`${TAG}_Image_nullShortCut`)
          .objectFit(ImageFit.Contain)
          .fillColor(this.imageFillColor)
          .height(!this.isPc ? StyleConstants.MENU_IMAGE_HEIGHT_PHONE : StyleConstants.MENU_IMAGE_HEIGHT_PC)
          .width(!this.isPc ? StyleConstants.MENU_IMAGE_WIDTH_PHONE : StyleConstants.MENU_IMAGE_WIDTH_PC)
          .margin({
            start: LengthMetrics.vp(StyleConstants.DEFAULT_12),
            end: !this.isPc ? LengthMetrics.vp(StyleConstants.DEFAULT_12) : LengthMetrics.vp(StyleConstants.DEFAULT_4),
          })
          .flexShrink(0)
          .fillColor(this.imageFillColor)
          .edgeAntialiasing(this.edgeAntialias)
      }
      Text(this.shortcutName).draggable(false)
        .id(`${TAG}_Text_shortCutName`)
        .fontColor(this.getTextFontColor())
        .fontSize(!this.isPc ? $r('sys.float.ohos_id_text_size_body2') : StyleConstants.MENU_FONTSIZE)
        .fontWeight(this.isNeedIcon ? FontWeight.Regular : FontWeight.Medium)
        .flexGrow(StyleConstants.DEFAULT_1)
        .flexShrink(StyleConstants.DEFAULT_1)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({
          start: !this.isNeedIcon ? LengthMetrics.vp(StyleConstants.DEFAULT_12) :
          LengthMetrics.vp(StyleConstants.DEFAULT_0),
        })
        .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
    }
    .border({
      radius: (this.isNeedIcon || this.isQXSPcMode) ?
        StyleConstants.MENU_EXTERNAL_RADIUS - StyleConstants.DEFAULT_4 : StyleConstants.DEFAULT_4
    })
    .padding({
      top: LengthMetrics.vp(StyleConstants.DEFAULT_4),
      bottom: LengthMetrics.vp(StyleConstants.DEFAULT_4),
      end: LengthMetrics.vp(StyleConstants.DEFAULT_12),
    })
    .constraintSize({
      minHeight: this.isNeedIcon ? StyleConstants.DEFAULT_44 : this.getAppMenuItemHeight(),
    })
    .width(this.menuWidth)
    .backgroundColor(this.getItemBackgroundColor())
    .onHover((isHover?: boolean) => {
      this.hoverState = isHover as boolean;
    })
    .onTouch((event?: TouchEvent) => {
      if (event?.type === TouchType.Down) {
        this.pressState = true;
      }
      if (event?.type === TouchType.Up) {
        this.pressState = false;
      }
    })
    .onMouse((event?: MouseEvent) => {
      if (event?.button === MouseButton.Left && event?.action === MouseAction.Press) {
        this.hoverState = false;
        this.pressState = true;
      } else if (event?.button === MouseButton.Left && event?.action === MouseAction.Release) {
        this.pressState = false;
      }
    })
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
    .menuDragStyle()
  }
}
