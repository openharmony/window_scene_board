/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import {
  AppItemInfo,
  CardItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  MultiSelectManager,
  EditModeUtils,
  multiSelectListenManger,
  MultiSelectListenerType,
  ListenerItemType,
  BaseViewModel,
  LiveFormSupportMgr,
} from '@ohos/launchercommon';
import { emitter } from '@kit.BasicServicesKit';
import { CommonConstants } from '@ohos/launchercommon';
import { AiSuggestionUtil } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUtil';
import { PageDesktopViewModel } from '../viewmodel/PageDesktopViewModel';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import lazy AppItem from './AppItem';
import FormItemRelative from './form/view/FormItemRelative';
import lazy FileFolderItem from './FileFolderItem';
import { PageDesktopDragHandler } from '../PageDesktopDragHandler';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import lazy { AiSuggestionItem } from '@ohos/aisuggestion';
import { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import { AbilityFormUtil } from '@ohos/aisuggestion/src/main/ets/default/utils/AbilityFormUtil';
import { ContractedFolder, DeskTopItemStyle } from '@ohos/launchercommon/Index';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  TraceUtil,
  DomainName,
  SingleContext
} from '@ohos/basicutils';
import { dragSnapshotHelper, SnapshotType, SnapshotListener } from '@ohos/componenthelper';
import { DeviceHelper, GlobalContext, HiSysEventUtil } from '@ohos/frameworkwrapper';
import { DragEventManager, SqueezeExtraParam, DragEventCallback } from '@ohos/componentdrag';
import { DropAnimationScene } from '@ohos/componentanimator';
import { DragConstants } from '@ohos/commonconstants';
import image from '@ohos.multimedia.image';
import { DesktopAppIcon } from './DesktopAppIcon';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import FormStackItem from './FormStackItem';
import { GravityAnimationComponent, GravityAnimationManager, GravityAnimationParameter } from '@ohos/componentanimator/Index';
import { FocusViewModel } from '../viewmodel/FocusViewModel';
import { multiSelectListenerManger } from '../MultiSelectListenerManager';
import { launcherStatusUtil } from '@ohos/windowscene/src/main/ets/utils/LauncherStatusUtil';
import lazy { outerAddAppIconManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAddAppIconManager';
import lazy { OuterAddAppIcon } from './OuterAddAppIcon';
import lazy { OverflowViewModel } from './liveform/viewmodel/OverflowViewModel';
import DesktopAddBubble from './desktopaddapp/DesktopAddBubble';
import { FormCenterViewManager, FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';

const TAG = 'DesktopItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export default struct DesktopItem {
  private item: GridLayoutItemInfo = new GridLayoutItemInfo();
  @Prop singleContext?: SingleContext;
  @Link iconSize: number;
  private mPageDesktopViewModel?: PageDesktopViewModel;
  private mFocusViewModel: FocusViewModel = FocusViewModel.getInstance();
  private mNameLines: number = 0;
  private mMaxNameLines: number = 0;
  private isPad: boolean = false;
  private mPageDesktopStyleConfig?: PageDesktopGridStyleConfig;
  private isFolderChange: boolean = false;
  @State mFileFolderOpacity: number = 1;
  private mTag: string = 'DesktopItem';
  private isDesktopItem: boolean = false;
  @State isSelect: boolean = false;
  @State isGainFocus: boolean = false;
  @State isCut: boolean = false;
  onItemSelect?: (item: GridLayoutItemInfo, pageIndex: number) => void;
  @ObjectLink desktopStyle: DeskTopItemStyle;
  @StorageProp('desktopIconChange') desktopIconChange: number = 0;
  private getIndexInSwiper: Function = (): number => 0;
  private swiperKey: number = -1;

  // 是否开始拖拽，起拖后置为true，开始落位时置为false
  @Provide isDragStart: boolean = false;

  // 是否处于拖拽过程中，起拖后置为true，落位动效完成时置为false
  @Provide isInDrag: boolean = false;

  // 是否是拖拽复制
  @Provide isDragPaste: boolean = false;

  // 挤位偏移量
  @Provide translateX: number = 0;
  @Provide translateY: number = 0;

  // 挤位效果参数
  @Provide itemOpacity: number = 1;
  private squeezeExtraParam: SqueezeExtraParam | undefined = undefined;

  // 桌面元素是否获焦
  @Provide isFocused: boolean = false;

  @Provide dragSnapshot?: image.PixelMap = undefined;
  @Link selectedStatus: boolean;
  private isOuterDesktop: boolean = false;

  private snapshotListener: SnapshotListener = {
    onSnapshotFinish: (image: image.PixelMap, type: SnapshotType, key: string) => {
      if (this.itemKey === key && (type === SnapshotType.DRAG || type === SnapshotType.BOTH)) {
        this.dragSnapshot = image;
      }
    },
    onSnapshotRelease: (type: SnapshotType, key: string) => {
      if (this.itemKey === key && type === SnapshotType.DRAG) {
        this.dragSnapshot = undefined;
      }
    },
  };

  private mDragEventCallback: DragEventCallback = {};
  private itemKey: string = '';
  private gravity: GravityAnimationComponent | null = null;

  private buildLog(item: GridLayoutItemInfo): boolean {
    let info = `typeId[${item.typeId}],iconId[${item.appIconId}],cardId[${item.cardId}],folderId[${item.folderId}],` +
      `formStackId[${item.formStackId}],rowColumn[${item.row},${item.column}], page[${item.page}],` +
      `area[${item.area?.[0]}, ${item.area?.[1]}],iconResource[${item.iconResource}],moduleName[${item.moduleName}],` +
      `abilityName[${item.abilityName}],appName[${item.appName}],cardDimension[${item.cardDimension}],status[${item.appStatus}]`;
    log.showWarn('build item %{public}s, isFolderChange:%{public}s, isOuterDesktop:%{public}s', info,
      this.isFolderChange, this.isOuterDesktop);
    let itemKey = this.mPageDesktopViewModel?.getForeachKey(item, this.desktopIconChange,
      false, 0, this.isOuterDesktop);
    log.showInfo('build item key %{public}s', itemKey);
    return true;
  }
  private isDesktopLayout: boolean = true;
  // 编辑模式多选拖拽事件监听
  private multiSelectListener?: MultiSelectListenerType = undefined;
  /** 卸载编辑模式多选拖拽事件监听 */
  private registerMultiSelectListener(parentId: string): void {
    this.multiSelectListener = {
      id: multiSelectListenManger.getListenerId(ListenerItemType.DESKTOP_ITEM, parentId, this.isOuterDesktop),
      onGather: (): void => {
        if ((launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) &&
          MultiSelectManager.getInstance().isItemSelected(this.item)) {
          log.showInfo(`${this.item.keyName} is onGather`);
          this.isDragStart = true;
          this.isInDrag = true;
        }
      },
      onItemDropped: (): void => {
        this.isDragStart = false;
        this.isInDrag = false;
      },
      onFinish: (): void => {
        if (this.isDragStart) {
          this.isDragStart = false;
        }
        this.isInDrag = false;
        /* 拖拽结束使受引力动效影响 */
        this.gravity?.setActive(true);
      }
    }
    multiSelectListenManger.register(this.multiSelectListener);
  }

  private unRegisterMultiSelectListener() {
    multiSelectListenManger.unregister(this.multiSelectListener);
  }

  private mixedSelectListener: MultiSelectListenerType = {
    id: ``,
    onDragging: (): void => {
      let currentSelect = this.mPageDesktopViewModel?.getCurrentSelectItems();
      this.mPageDesktopViewModel?.setMultiDragStart(currentSelect !== undefined && currentSelect?.length > 1, TAG);
      log.showError(`this.currentSelect: ${currentSelect?.length}`);
      if (currentSelect?.indexOf(this.mPageDesktopViewModel?.getItemKeyByType(this.item,
        this.isOuterDesktop) as string) !== -1 &&
        this.item.typeId !== CommonConstants.TYPE_CARD &&
        this.item.typeId !== CommonConstants.TYPE_REGION_FOLDER) {
        log.showInfo(`Impact Visible. isInDrag set true.`);
        this.isDragStart = true;
        this.isInDrag = true;
        this.isDragPaste = PageDesktopDragHandler.getInstance(this.singleContext).getIsDragPaste();
      }
    },
    onDropping: (): void => { this.isDragStart = false; },
    onFinish: (): void => {
      log.showInfo(`Impact Visible. mixedSelectListener onFinish`);
      if (this.isDragStart) {
        this.isDragStart = false;
      }
      if (this.isDragPaste) {
        PageDesktopDragHandler.getInstance(this.singleContext).setIsDragPaste(false);
        this.isDragPaste = false;
      }
      // 区分多选和单选拖拽，多选拖拽无动效，此时isInDrag可以置为false，单选拖拽需等动效完成后置为false
      let currentSelect = this.mPageDesktopViewModel?.getCurrentSelectItems();
      if (this.mPageDesktopViewModel?.getMultiDragStart() || (currentSelect !== undefined && currentSelect.length > 1)) {
        this.isInDrag = false;
      }
    }
  }

  @Builder
  appIconBuild() {
    if (!DeviceHelper.isPC()) {
      DesktopAppIcon({
        singleContext: this.singleContext,
        item: this.item as Object as AppItemInfo,
        maxNameLines: this.mMaxNameLines,
        getIndexInSwiper: this.getIndexInSwiper,
        isDesktopItem: this.isDesktopItem,
        isSelect: this.isSelect,
        iconSize: this.iconSize,
        isGainFocus: this.isGainFocus,
        desktopStyle: this.desktopStyle,
        isDragStart: this.isDragStart,
        isInDrag: this.isInDrag,
        // 拖拽挤位相关
        translateX: this.translateX,
        translateY: this.translateY,
      })
    } else {
      AppItem({
        singleContext: this.singleContext,
        desktopStyle: this.desktopStyle,
        item: this.item as Object as AppItemInfo,
        mPageDesktopViewModel: this.mPageDesktopViewModel,
        mMaxNameLines: this.mMaxNameLines,
        getIndexInSwiper: this.getIndexInSwiper,
        isDesktopItem: this.isDesktopItem,
        isSelect: this.isSelect,
        isDragStart: this.isDragStart,
        isInDrag: this.isInDrag,
        mIconSize: this.iconSize,
        isGainFocus: this.isGainFocus,
        onItemSelect: (item: GridLayoutItemInfo) => this.onItemSelect?.(item, this.getIndexInSwiper()),
      }).id(`${this.mTag}_AppItem_${this.item.bundleName}_${this.item.appIconId}`)
        .translate({ x: CheckEmptyUtils.isEmpty(this.desktopStyle) ? 0 : this.desktopStyle.translateX })
        .opacity(CheckEmptyUtils.isEmpty(this.desktopStyle) ? 1 : this.desktopStyle.alpha)
    }
  }

  build() {
    if (this.buildLog(this.item)) {
        if (this.item.typeId === CommonConstants.TYPE_APP || this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          this.appIconBuild();
        } else if (this.item.typeId === CommonConstants.TYPE_FOLDER && !DeviceHelper.isPC()) {
          ContractedFolder({
            folderId: this.item.folderId,
            getIndexInSwiper: this.getIndexInSwiper,
            desktopStyle: this.desktopStyle
          })
        } else if (this.item.typeId === CommonConstants.TYPE_FILE_FOLDER) {
          FileFolderItem({
            singleContext: this.singleContext,
            fileFolderItem: this.item,
            isSelect: this.isSelect,
            isGainFocus: this.isGainFocus,
            isCut: this.isCut,
            onItemSelect: (item: GridLayoutItemInfo) => this.onItemSelect?.(item, this.getIndexInSwiper()),
            isDragStart: this.isDragStart,
            isInDrag: this.isInDrag,
            isDragPaste: this.isDragPaste,
            mPageDesktopViewModel: this.mPageDesktopViewModel,
            getContainerViewModel: () => {
              return this.mPageDesktopViewModel as BaseViewModel;
            },
          }).id(`${this.mTag}_FileFolderItem_${this.item.ino}`)
            .translate({ x: CheckEmptyUtils.isEmpty(this.desktopStyle) ? 0 : this.desktopStyle.translateX,
              y: CheckEmptyUtils.isEmpty(this.desktopStyle) ? 0 : this.desktopStyle.translateY})
            .opacity(CheckEmptyUtils.isEmpty(this.desktopStyle) ? 1 : this.desktopStyle.alpha)
            .scale(this.getScale())
        } else if (this.item.typeId === CommonConstants.TYPE_CARD &&
          AiSuggestionUtil.isVoiceAbilityForm(this.item.bundleName, this.item.abilityName)) {
          AiSuggestionItem({
            formItem: this.item,
            formMarginTop: this.mPageDesktopViewModel?.getIconMarginVertical(),
            mNameLines: this.mNameLines,
            mPageDesktopDragHandler: PageDesktopDragHandler.getInstance(this.singleContext),
            mTag: this.mTag,
            getIndexInSwiper: this.getIndexInSwiper,
            isDesktopItem: this.isDesktopItem,
            desktopStyle: this.desktopStyle,
            isOuterDesktop: this.isOuterDesktop
          })
        } else if (this.item.typeId === CommonConstants.TYPE_CARD) {
          FormItemRelative({
            singleContext: this.singleContext,
            mFormItem: this.item as Object as CardItemInfo,
            mFormMarginTop: this.mPageDesktopViewModel?.getIconMarginVertical(),
            mPageDesktopViewModel: this.mPageDesktopViewModel,
            getIndexInSwiper: this.getIndexInSwiper,
            mIsDesktopItem: this.isDesktopItem,
            mTag: this.mTag,
            mDefaultType: DeviceHelper.isPC() ? false : true,
            desktopStyle: this.desktopStyle,
            isOuterDesktop: this.isOuterDesktop,
          })
        } else if (this.isFormStackItem()) {
          FormStackItem({
            singleContext: this.singleContext,
            mFormStackItem: this.item as Object as FormStackItemInfo,
            mNameLines: this.mNameLines,
            getIndexInSwiper: this.getIndexInSwiper,
            mComponentId: `${this.mTag}_FormStackItem_${this.item.formStackId}`,
            mDesktopStyle: this.desktopStyle,
            isOuterDesktop: this.isOuterDesktop,
          })
        } else if (this.isOuterDesktop && outerAddAppIconManager.isAddAppIcon(this.item)) {
          OuterAddAppIcon({
            iconSize: this.iconSize,
            translateX: this.translateX,
            translateY: this.translateY
          });
        } else if (this.item.typeId === CommonConstants.TYPE_ADD) {
          DesktopAddBubble({
            appItemWidth: this.iconSize,
            desktopStyle: this.desktopStyle,
          })
        }
    }
  }

  isFormStackItem(): boolean | undefined {
    return this.item.typeId === CommonConstants.TYPE_FORM_STACK && this.item.layoutInfo &&
    this.item.layoutInfo[0]?.[0] && this.item.layoutInfo[0].length > 1;
  }

  private getScale(): ScaleOptions {
    if (CheckEmptyUtils.isEmpty(this.desktopStyle)) {
      return {
        x: 1,
        y: 1,
      }
    } else {
      return {
        x: this.desktopStyle.scale,
        y: this.desktopStyle.scale,
        centerX: this.desktopStyle.unLockAnimate ? this.desktopStyle.centerX : '50%',
        centerY: this.desktopStyle.unLockAnimate ? this.desktopStyle.centerY : '50%',
      }
    }
  }

  onSelectStatusChange(selectStatus: boolean): void {
    let key = this.mPageDesktopViewModel?.getItemKeyByType(this.item, this.isOuterDesktop);
    log.showDebug(`onSelectStatusChange key:${key}, isSelect:${this.isSelect}, selectStatus: ${selectStatus}`);
    this.isSelect = selectStatus;
    this.item.isSelect = selectStatus;
    this.selectedStatus = selectStatus;
  }

  onCutStatusChange(cutStatus: boolean): void {
    log.showInfo(`onCutStatusChange,cutStatus: ${cutStatus}, ino: ${this.item?.ino}`);
    this.isCut = cutStatus;
  }

  onFocusStatusChange(isGainFocus: boolean): void {
    this.isGainFocus = isGainFocus;
  }

  private startGravityRestoreAnimation(param: GravityAnimationParameter): void {
    log.showInfo('start to restore page-item gravity animation on %{public}s, duration %{public}d',
      this.item.bundleName, param.waveDuration);
    const id = 'SwiperItemGravityAnimationBack.' + this.item.bundleName + '.' + this.item.keyName;
    TraceUtil.startTraceWithTaskId(DomainName.HOME, id, 1);
    animateTo({
      curve: param.waveCurve,
      duration: param.waveDuration,
      onFinish: () => {
        TraceUtil.endTraceWithTaskId(DomainName.HOME, id, 1);
          GravityAnimationManager.getInstance().markFinish(param);
      }
    }, () => {
      this.translateX = 0;
      this.translateY = 0;
    })
  }

  private startGravityAnimation(param: GravityAnimationParameter): void {
    log.showInfo('start page-item gravity animation on %{public}s, delay %{public}d, duration %{public}d, ' +
      'from [%{public}d, %{public}d] -> [%{public}d, %{public}d]',
      this.item.bundleName, param.delay, param.waveDuration, param.now.x, param.now.y,
      param.waveCrest.x, param.waveCrest.y);
    const id = 'SwiperItemGravityAnimation.' + this.item.bundleName + '.' + this.item.keyName;
    TraceUtil.startTraceWithTaskId(DomainName.HOME, id, 1);
    animateTo({
      curve: param.waveCurve,
      delay: param.delay * 1000,
      duration: param.waveDuration,
      onFinish: () => {
        this.startGravityRestoreAnimation(param);
        TraceUtil.endTraceWithTaskId(DomainName.HOME, id, 1);
      }
    }, () => {
      this.translateX = param.waveCrest.x - param.now.x;
      this.translateY = param.waveCrest.y - param.now.y;
    });
  }

  private isValidPostion(): boolean {
    if (this.item.row !== undefined && this.item.area !== undefined && this.item.column !== undefined) {
      return true;
    }
    return false;
  }

  /**
   * 由于桌面图标拖拽不再重建，导致DesktopItem不知道位置已经刷新（被拖元素和挤位元素）
   * 这里就只能加上刷新机制。当图标落位和被挤位有通知的时候，就可以去掉这个逻辑，提前在通知里更新
   */
  private updatePosition(): void {
    if (this.gravity && this.isValidPostion()) {
      /*
       * 发现拖拽挤位后，被挤位的元素在当前的desktopitem的item里没有更新到最新的数据；而SwiperPage是已经更新了。
       * 因此先使用缓存里的数据来更新索引。
       */
      let cached = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem(this.item);
      if (!cached) {
        log.showError('cannot get item %{public}s/%{public}s cache info', this.item.typeId, this.item.bundleName);
        return;
      }
      let cachedPos: number[] = GridLayoutUtil.getIconCenterPosition(cached.row, cached.column, cached.area,
        this.getIndexInSwiper());
      log.showInfo('update page-item gravity animation with type: %{public}d, id: %{public}s, page: %{public}d, ' +
        'row: %{public}d, column: %{public}d, size %{public}d * %{public}d, x: %{public}d, y: %{public}d',
        cached.typeId, cached.bundleName, this.getIndexInSwiper(), cached.row, cached.column,
        (cached.area as number[])[0], (cached.area as number[])[1], cachedPos[0], cachedPos[1]);

      this.gravity.setLayoutInfo(this.swiperKey,
        cached.row as number,
        cached.column as number,
        (cached.area as number[])[0],
        (cached.area as number[])[1]);
      this.gravity.setPosition(cachedPos[0], cachedPos[1]);
    }
  }

  private registerGravityAnimation(): void {
    /* 大小文件夹转换用的desktopitem容器不参与引力动效 */
    if (this.isValidPostion() && !this.isFolderChange) {
      const pos: number[] = GridLayoutUtil.getIconCenterPosition(this.item.row, this.item.column, this.item.area,
        this.getIndexInSwiper());
      let ranks: number[] = this.item.area as number[];
      log.showInfo('create page-item gravity animation with drag %{public}s type: %{public}d, ' +
        'id: %{public}s, page: %{public}d, row: %{public}d, ' +
        'column: %{public}d, size %{public}d * %{public}d, x: %{public}d, y: %{public}d',
        this.isInDrag, this.item.typeId, this.item.bundleName, this.getIndexInSwiper(), this.item.row, this.item.column,
        ranks[0], ranks[1], pos[0], pos[1]);
      /* 如果本组件解决了挤位、重排场景下自身row、column可感知问题，就不需要注册forceUpdateLayoutCallback */
      this.gravity = new GravityAnimationComponent(
        (param: GravityAnimationParameter) => { this.startGravityAnimation(param); },
        () => { this.updatePosition(); });
      this.gravity.setLayoutInfo(this.swiperKey,
        this.item.row as number,
        this.item.column as number,
        ranks[0],
        ranks[1]);
      this.gravity.setPosition(pos[0], pos[1]);
      /* 处于拖拽状态的控件，自身不应该受到引力动效影响（后续优化了落位的build问题，就是有翻页落位场景需要屏蔽） */
      this.gravity.setActive(!this.isInDrag);
      GravityAnimationManager.getInstance().addComponent(this.gravity);
    }
  }

  private unregisterGravityAnimation(): void {
    if (this.gravity) {
        GravityAnimationManager.getInstance().removeComponent(this.gravity);
        this.gravity = null;
    }
  }

  aboutToAppear() {
    this.itemKey = GridLayoutUtil.generateUniqueKey(this.item);
    log.showInfo('aboutToAppear getIndexInSwiper(): %{public}d ', this.getIndexInSwiper());
    // 对overflow卡片进行状态禁用的监听注册
    if (LiveFormSupportMgr.getInstance().isSupportGameCard() || LiveFormSupportMgr.getInstance().isSupportLiveForm()) {
      OverflowViewModel.getInstance().registerOverflowGrayAppEventListener(this.item);
    }
    this.initDragEventCallback();
    this.registerDragEvent();
    this.registerSnapshotListener();
    this.initDragParam();
    this.registerGravityAnimation();
    let key = this.mPageDesktopViewModel?.getItemKeyByType(this.item, this.isOuterDesktop) as string;
    if (this.isNeedSelected()) {
      log.showDebug(`aboutToAppear registerSelectChangeListener key:${key}, item selected: ${this.item.isSelect}`);
      this.mPageDesktopViewModel?.registerSelectChangeListener(key, this);
      this.isSelect = this.item.isSelect;
    }
    // 手机平板多选拖拽事件监听
    this.registerMultiSelectListener(this.itemKey);
    // Pc多选拖拽事件监听
    this.mixedSelectListener.id = `desktopItem_${GridLayoutUtil.generateUniqueKey(this.item)}`;
    multiSelectListenerManger.register(this.mixedSelectListener);
    this.mFocusViewModel.registerFocusEventListener(key, this);
  }

  private initDragParam(): void {
    const dragItems = PageDesktopDragHandler.getInstance(this.singleContext).getDragItems() ?? [];
    const itemIndex = dragItems.findIndex(item => GridLayoutUtil.generateUniqueKey(item) === this.itemKey);
    if (dragItems.length > 1 && !DeviceHelper.isPC()) {
      this.isDragStart = itemIndex !== -1;
      this.isInDrag = itemIndex !== -1;
    } else {
      let scene: DropAnimationScene = DropAnimationScene.SCENE_DESKTOP;
      const isInDropAnimation = dropAnimationManager.isInDropAnimation(scene, this.itemKey);
      this.isDragStart = (itemIndex !== -1) && !isInDropAnimation;
      this.isInDrag = this.isDragStart || isInDropAnimation;
    }
    log.showInfo(`initDragParam itemKey:${this.itemKey} isDragStart:${this.isDragStart} isInDrag:${this.isInDrag}`);
  }

  private isNeedSelected(): boolean {
    if (!this.isDesktopLayout || !DeviceHelper.isPC()) {
      return false;
    }
    if (this.item.typeId === CommonConstants.TYPE_APP || this.item.typeId === CommonConstants.TYPE_FILE_FOLDER ||
      this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      return true;
    }
    return false;
  }

  aboutToDisappear() {
    this.unRegisterDragEvent();
    this.unregisterSnapshotListener();
    let key = this.mPageDesktopViewModel?.getItemKeyByType(this.item, this.isOuterDesktop) as string;
    if (this.isDesktopLayout) {
      log.showDebug(`aboutToDisappear unregisterSelectChangeListener key:${key}`);
      this.mPageDesktopViewModel?.unregisterSelectChangeListener(key, this);
    }
    this.unregisterGravityAnimation();
    this.unRegisterMultiSelectListener();
    multiSelectListenerManger.unregister(this.mixedSelectListener);
    this.mFocusViewModel.unregisterFocusEventListener(key, this);
  }

  onFocusedEvent(isFocused: boolean): void {
    let isDesktopFocused: boolean = this.mPageDesktopViewModel?.getDesktopFocusState() as boolean;
    let key: string = this.mPageDesktopViewModel?.getItemKeyByType(this.item, this.isOuterDesktop) as string;
    log.showDebug(`onFocusedEvent item:${key}, isFocused:${isFocused}, isDesktopFocused:${isDesktopFocused}`);
    // 桌面处在获焦态时才设置组件获焦
    if (isDesktopFocused) {
      this.isFocused = isFocused;
    }
  }

  private updatePcSqueezeExtraParam(squeezeExtraParam?: SqueezeExtraParam): void {
    if (!squeezeExtraParam) {
      this.squeezeExtraParam = undefined;
      return;
    }
    this.squeezeExtraParam = {
      delayTime: squeezeExtraParam?.delayTime ?? 0,
      opacity: squeezeExtraParam?.opacity ?? 1,
    };
  }

  private onStartSqueezedEvent(translatePosition: number[][], squeezeExtraParam?: SqueezeExtraParam): void {
    if (translatePosition === undefined || translatePosition === null) {
      log.showError('onEventhubItemMoveEvent params error');
      return;
    }
    let endX: number = translatePosition[1][0] - translatePosition[0][0];
    let endY: number = translatePosition[1][1] - translatePosition[0][1];
    log.showDebug('ItemMoveEvent, name:%{public}s, endX:%{public}d, endY:%{public}d', this.item.bundleName, endX, endY);
    if (editModeManager.isInEditMode()) {
      endX /= EditModeUtils.getDesktopScale();
      endY /= EditModeUtils.getDesktopScale();
    }
    this.updatePcSqueezeExtraParam(squeezeExtraParam);
    this.itemSqueezedAnimate(endX, endY);
    const pos: number[] = GridLayoutUtil.getIconCenterPosition(this.item.row, this.item.column, this.item.area,
      this.getIndexInSwiper());
    this.gravity?.setOffset(pos[0] + endX, pos[1] + endY);
  }

  private initDragEventCallback(): void {
    if (this.isFolderChange) {
      return;
    } else {
      this.mDragEventCallback = {
        onItemDragStartEvent: (): void => {
          log.showInfo('onItemDragStartEvent, itemKey = %{public}s', this.itemKey);
          let currentSelect = this.mPageDesktopViewModel?.getCurrentSelectItems();
          if (!DeviceHelper.isPhone() && currentSelect !== undefined && !(currentSelect.length > 1)) {
            this.doSelect();
          }
          this.isInDrag = true;
          this.isDragStart = true;
          const containFileDragItemInfo: boolean = PageDesktopDragHandler.getInstance(this.singleContext).getDragItems()?.find(item =>
            item.typeId === CommonConstants.TYPE_FILE_FOLDER) === undefined ? false : true;
          const isCtrlKeyDown: boolean = AppStorage.get<boolean>('isCtrlKeyDown') ?? false;
          const isAltKeyDown: boolean = AppStorage.get<boolean>('isAltKeyDown') ?? false;
          this.isDragPaste = (isCtrlKeyDown || isAltKeyDown) && containFileDragItemInfo;
          log.showInfo('Impact Visible. onItemDragStartEvent,isDragPaste = %{public}s', this.isDragPaste);
          PageDesktopDragHandler.getInstance(this.singleContext).setIsDragPaste(this.isDragPaste);
            /* 拖拽时使自身不可参与引力动效 */
          this.gravity?.setActive(false);
        },
        onItemDropStartEvent: (): void => {
          log.showInfo('onItemDropStartEvent, itemKey = %{public}s', this.itemKey);
          let currentSelect = this.mPageDesktopViewModel?.getCurrentSelectItems();
          if (currentSelect !== undefined && !(currentSelect.length > 1)) {
            this.doSelect();
          }
          this.isDragStart = false;
          if (!dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP, this.itemKey)) {
            this.isInDrag = false;
          }
          AppStorage.setOrCreate('shiftStartItem', this.item);
        },
        onItemDropEndEvent: (): void => this.onItemDropEnd(),
        onStartSqueezedEvent: (translatePosition: number[][], squeezeExtraParam?: SqueezeExtraParam): void => {
          this.onStartSqueezedEvent(translatePosition, squeezeExtraParam);
        },
        onCancelSqueezedEvent: (hasAnimation: boolean): void => {
          log.showInfo('onCancelSqueezedEvent key:%{public}s translateX:%{public}d translateY:%{public}d' +
            ' hasAnimation:%{public}s', this.itemKey, this.translateX, this.translateY, hasAnimation);
          if (hasAnimation) {
            this.itemSqueezedAnimate(0, 0);
          } else {
            this.translateX = 0;
            this.translateY = 0;
            this.itemOpacity = 1;
          }
          this.gravity?.setOffset(0, 0);
        }
      }
    }
  }

  private onItemDropEnd(): void {
    log.showInfo('onItemDropEndEvent, itemKey = %{public}s', this.itemKey);
    this.isInDrag = false;
    this.isDragStart = false;
    // pc场景由于鼠标按住后可立刻进行拖拽，应用侧来不及完成截图，故不主动释放截图，在快拖场景下提升拖拽性能。
    // 手机场景由于需要用手长按才能拖拽，能够完成截图，故可将之前的截图主动释放降低内存。
    if (!DeviceHelper.isPC()) {
      dragSnapshotHelper.releaseSnapshot(SnapshotType.BOTH, this.itemKey);
    } else {
      GlobalContext.getContext()?.eventHub.emit(CommonConstants.DESKTOP_ITEM_ENABLE_RENDER_GROUP, true);
    }
    this.dragSnapshot = undefined;
    /* 拖拽结束使受引力动效影响 */
    this.gravity?.setActive(true);
    let isDrag: boolean =  AppStorage.get('isDragFomCenter') ?? false;
    if (isDrag) {
      GlobalContext.getContext().eventHub.emit('myOnDragEnd');
    }
  }

  private doSelect(): void {
    let key = this.mPageDesktopViewModel?.getItemKeyByType(this.item, this.isOuterDesktop);
    if (key) {
      this.mPageDesktopViewModel?.onSelectItemChange([key], true);
    }
  }

  private itemSqueezedAnimate(endX: number, endY: number): void {
    if (this.squeezeExtraParam !== undefined) {
      this.itemSqueezedAnimateWithExtraParam(endX, endY);
      return;
    }
    animateTo({
      duration: DragConstants.SQUEEZED_ANIMATION_DURATION,
      curve: DragConstants.SQUEEZED_CURVES
    }, () => {
      this.translateX = endX;
      this.translateY = endY;
    });
  }

  private itemSqueezedAnimateWithExtraParam(endX: number, endY: number): void {
    animateTo({
      curve: DragConstants.SQUEEZED_CURVES_FOR_PC,
      delay: this.squeezeExtraParam?.delayTime ?? 0,
    }, () => {
      this.translateX = endX;
      this.translateY = endY;
      if (endX === 0 && endY === 0) {
        this.itemOpacity = 1;
      } else {
        this.itemOpacity = this.squeezeExtraParam?.opacity ?? 1;
      }
    });
  }

  private registerDragEvent(): void {
    if (this.isFolderChange) {
      return;
    }
    log.showInfo('registerDragEvent, itemKey = %{public}s', this.itemKey);
    DragEventManager.getInstance(this.isOuterDesktop).registerDragEvent(this.mDragEventCallback, this.itemKey);
  }

  private unRegisterDragEvent(): void {
    if (this.isFolderChange) {
      return;
    }
    log.showInfo('unregisterDragEvent, itemKey = %{public}s', this.itemKey);
    DragEventManager.getInstance(this.isOuterDesktop).unRegisterDragEvent(this.mDragEventCallback, this.itemKey);
  }

  private registerSnapshotListener(): void {
    dragSnapshotHelper.registerSnapshotListener(this.snapshotListener, this.itemKey);
  }

  private unregisterSnapshotListener(): void {
    dragSnapshotHelper.unregisterSnapshotListener(this.snapshotListener, this.itemKey);
  }
}
