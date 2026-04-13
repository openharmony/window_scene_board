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
import { AppItemInfo, CommonConstants, GridLayoutItemInfo } from '../../TsIndex';
import { dragController, type Position } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DragDataType, DragExtraInfo } from '@ohos/componentdrag';
import { MultiSelectStyleConfig } from './MultiSelectStyleConfig';
import { ImageModifier } from '@ohos.arkui.modifier';

const TAG: string = 'MultiSelectData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export enum MultiSelectStatusEnum {
  Exited = 0, // 退出多选状态
  Entered = 1, //进入多选状态 未选择图标
  Selecting = 2, // 进入多选状态 已选择图标
  beforeGather = 3, //进入汇聚逻辑， 单未开始汇聚动效
  Gathering = 4, // 汇聚状态
  Dragging = 5, // 拖拽中
  Dropping = 6, // 落位中
}

export enum MultiSelectMode {
  /** 默认状态 */
  INIT = 0,
  /** 单选状态 */
  SINGLE = 1,
  /** 多选状态 */
  MULTI = 2
}

/**
 *  多选拖拽事件监听对象
 */
export class MultiSelectListenerType {
  public id: string = '';

  /**
   * 进入多选模式回调
   */
  public onEnter?: () => void;

  /**
   * 开始选择回调
   */
  public onUpdatingMultiSelectMap?: () => void;

  /**
   * 触发长按效果事件回调 单点发送
   */
  public onLongPress?: () => void;

  /**
   * 开始汇聚之前回调
   */
  public beforeGather?: () => void;

  /**
   * 开始汇聚回调
   */
  public onGather?: () => void;

  /**
   * 汇聚过程中拖拽移动
   */
  public onMoveWhenGathering?: (touchPos: Position) => void;

  /**
   * 汇聚过程中落位
   */
  public onDropWhenGathering?: () => void;

  /**
   * 开始拖拽回调
   */
  public onDragging?: () => void;

  /**
   * 开始落位回调
   */
  public onDropping?: () => void;

  /** 落位完成回调 定点发送 */
  public onItemDropped?: () => void;

  /**
   * 拖拽落位完成回调
   */
  public onFinish?: () => void;

  /**
   * 退出多选模式回调
   */
  public onExit?: () => void;

  /**
   * 通知多选框更新自身状态
   */
  public onUpdateState?: () => void;

  /** 拖拽异常， 手动触发落位 */
  public onCustomDrop?: (touchPos: Position) => void;

  /**
   * 应用完成拖拽后显示名称回调 定点发送
   */
  public onShowAppName?: () => void;
}

/**
 * checkbox父组件类型枚举
 */
export enum CheckboxParentEnum {
  /**
   * 桌面应用
   */
  App = 'app',

  /**
   * 文件夹
   */
  Folder = 'folder',

  /**
   * 文件夹内应用
   */
  AppInFolder = 'appInFolder',
}

/**
 * checkbox父组件布局方式枚举
 */
export enum CheckboxParentLayoutEnum {
  Relative = 'relative',
  Stack = 'Stack'
}

export class CheckboxVmConstructorType {
  /**
   *  checkbox所在组件的类型
   */
  public parentType: CheckboxParentEnum = CheckboxParentEnum.App;
  /**
   *  checkbox所在组件的id
   */
  public parentId: string = '';
  /**
   *  用于获取组件范围的id
   */
  public rectId: string = '';
  /**
   *  所属的folder checkboxId parentType为AppInFolder时要填
   */
  public belongFolderCheckboxId?: string;
  /**
   *  父组件AppItemInfo 或者gridLayoutItemInfo转换
   */
  public parentItemInfo: AppItemInfo = new AppItemInfo();
  /**
   *  父组件宽度 用于控制checkbox位置和汇聚动效图标渲染
   */
  public iconSize: number = 0;
  /**
   * 父组件圆角
   */
  public radius: number = 0;
  /**
   * 是否在落位过程中
   */
  public isInDrag: boolean = false;

  public isOuterDesktop: boolean = false;
}

/**
 * 多选框信息类型
 * @checkboxId
 * @parentType checkbox所在组件的类型
 * @parentId checkbox所在组件的id
 * @belongFolderCheckboxId 所属的folder checkboxId parentType === AppInFolder时要填
 */
export class CheckboxInfoType extends CheckboxVmConstructorType {
  /**
   * checkbox选择状态
   */
  public checkState: CheckboxCheckState = new CheckboxCheckState();
}

/**
 * 多选应用图标类型
 */
export class GatherPositionInfoType {
  public width: number = 0;
  public height: number = 0;
  // 图标默认位置
  public defaultPosition: Position = { x: 0, y: 0 };
  // 图标目标位置
  public targetPosition: Position = { x: 0, y: 0 };
}

export class CheckboxCheckState {
  private state: number = 0;

  /**
   * 当前是否选中
   * @returns
   */
  public isSelected(): boolean {
    return this.state > 0;
  };

  /**
   * 切换选中状态
   * @returns 返回切换后的状态
   */
  public change(): boolean {
    this.state = this.isSelected() ? 0 : 1;
    return this.isSelected();
  };

  /**
   * 增加选中数量 文件夹checkbox专用
   * @returns 返回切换后的状态
   */
  public add(): boolean {
    this.state += 1;
    return this.isSelected();
  };

  /**
   * 减少选中数量  文件夹checkbox专用
   * @returns 返回切换后的状态
   */
  public sub(): boolean {
    this.state = Math.max(0, this.state - 1);
    return this.isSelected();
  };

  /**
   * 直接设置选中状态
   * @returns 返回切换后的状态
   */
  public setSelectedStatus(isSelected: boolean = false): boolean {
    this.state = isSelected ? 1 : 0;
    return this.isSelected();
  };
}

export class FolderAppGatherInfoType {
  public index: number = 0;
  public folderMaxCount: number = 0;
}

//多选管理 选中列表对象
export class MultiSelectItemType {
  public iconSize: number = 0;
  public parentItemInfo: AppItemInfo = new AppItemInfo();
  public width: number = 0;
  public height: number = 0;
  public defaultX: number = 0;
  public defaultY: number = 0;
  public targetX: number = 0;
  public targetY: number = 0;
  public image?: image.PixelMap;
  public page: number = 0;
  public belongId?: string;
  public radius: number = 0;
  public parentId: string = '';
  public zIndex: number = 0;
  public animationType: AnimationType = AnimationType.FADE_GATHER;
}

export class GatherIconStateConstructorType {
  public width: number = 0;
  public height: number = 0;
  public position: Position = { x: 0, y: 0 };
  public zIndex: number = 0;
  public image?: image.PixelMap;
  public visible: boolean = false;
}

export class GridItemRect {
  public width: number = 0;
  public height: number = 0;
  public leftTopX: number = 0;
  public leftTopY: number = 0;
  public centerX: number = 0;
  public centerY: number = 0;
}

/**
 * 多选模式状态
 */
@Observed
export class MultiSelectStatus {
  private status: MultiSelectStatusEnum = MultiSelectStatusEnum.Exited;
  private isEnteredState: BooleanState = new BooleanState(false);

  public get showCheckbox(): boolean {
    return this.status !== MultiSelectStatusEnum.Exited;
  };

  public get isEntered(): boolean {
    return this.status !== MultiSelectStatusEnum.Exited;
  };

  /**
   * 是否正在汇聚、拖拽、落位
   */
  public get inGatherOrDragOrDrop(): boolean {
    return this.status >= MultiSelectStatusEnum.beforeGather;
  }

  public getEnteredState(): BooleanState {
    return this.isEnteredState;
  };

  public isSelectAble(): boolean {
    return this.status === MultiSelectStatusEnum.Entered || this.status === MultiSelectStatusEnum.Selecting;
  };

  public setStatus(targetStatus: MultiSelectStatusEnum): void {
    if (this.status !== targetStatus) {
      this.status = targetStatus;
      log.showInfo(`set multiSelectStatus as ${targetStatus}`);
      this.isEnteredState.set(this.isEntered);
    }
  };

  public inStatus(status: MultiSelectStatusEnum): boolean {
    return this.status === status;
  };
}

/**
 * 通用boolean类型状态变量
 */
@Observed
export class BooleanState {
  public value: boolean;

  constructor(val: boolean) {
    this.value = val;
  };

  public set(val: boolean): void {
    if (this.value !== val) {
      this.value = val;
    }
  };
}

/**
 * 多选框视图控制状态变量
 */
@Observed
export class CheckboxViewState {
  public show: boolean = false;
  public checked: boolean = false;

  public setShow(show: boolean): void {
    if (this.show !== show) {
      this.show = show;
    }
  };

  public setChecked(val: boolean): void {
    if (this.checked !== val) {
      this.checked = val;
    }
  };

  public reSet(): void {
    this.setShow(false);
    this.setChecked(false);
  };
}

/**
 * 多选拖拽事件类参数
 */
export class MultiSelectDragParamsType {
  /**
   * 拖拽图标列表
   */
  public dragItemImageList: image.PixelMap[] = [];

  /**
   * 拖拽跟手点
   */
  public touchPoint?: Position;
  /**
   * 拖拽图标圆角
   */
  public imageRadius: number = 0;

  /**
   * 拖拽开始回调
   */
  public onDragStart?: () => void;

  /**
   * 拖拽松手回调
   */
  public onDragEnd?: () => void;

  /**
   * 拖拽失败
   */
  public onDragCancel?: () => void;

  /**
   * 拖拽流程结束
   */
  public onDragFinish?: () => void;
}

/**
 * 多选拖拽多拖拽事件封装类
 */
export class MultiSelectDrag {
  private dragAction: dragController.DragAction | null = null;
  private dragParams: MultiSelectDragParamsType | null;
  private dragging: boolean = false;
  public get isDragging(): boolean {
    return this.dragging;
  }

  constructor(params: MultiSelectDragParamsType) {
    log.showInfo(`createDrag touchPoint:%{public}d %{public}d, dragItemImage length: %{public}d`,
      params.touchPoint?.x, params.touchPoint?.y, params.dragItemImageList.length);
    this.dragParams = params;
  };

  /**
   * 触发拖拽
   */
  public async executeDrag(): Promise<boolean> {
    try {
      const modifier = new ImageModifier();
      modifier.borderRadius(this.dragParams?.imageRadius).opacity(MultiSelectStyleConfig.FIRST_ICON_OPACITY);
      const dragInfo: dragController.DragInfo = {
        pointerId: 0,
        touchPoint: this.dragParams?.touchPoint,
        previewOptions: {
          mode: DragPreviewMode.DISABLE_SCALE,
          modifier: modifier
        }
      };
      const dragItemInfoList: DragItemInfo[] = [];
      this.dragParams?.dragItemImageList
        .slice(0, MultiSelectStyleConfig.MAX_DRAG_ITEM_COUNT)
        .forEach(image => {
          dragItemInfoList.push({
            pixelMap: image,
            extraInfo: new DragExtraInfo(DragDataType.APP).setRadius(-1).toString(),
          });
        });

      this.dragAction = dragController.createDragAction(
        dragItemInfoList,
        dragInfo
      );
      this.dragAction.on('statusChange', (dragAndDropInfo: dragController.DragAndDropInfo) => {
        this.handleDragCallback(dragAndDropInfo);
      });
      log.showWarn('MultiSelect start drag');
      await this.dragAction?.startDrag();
      return true;
    } catch (error) {
      log.showError('MultiSelect start drag Error:' + error.message);
    }
    this.onDragCancel();
    this.onDragFinish();
    return false;
  };

  public release(): void {
    this.dragParams = null;
  }

  /**
   * 拖拽事件处理
   */
  protected handleDragCallback(dragAndDropInfo: dragController.DragAndDropInfo): void {
    if (dragAndDropInfo.status === dragController.DragStatus.STARTED) {
      log.showInfo('Drag start');
      this.dragging = true;
      this.onDragStart();
    } else if (dragAndDropInfo.status === dragController.DragStatus.ENDED) {
      log.showInfo('Drag end');
      this.dragging = false;
      if (!this.dragAction) {
        return;
      }
      this.dragAction.off('statusChange');
      this.dragAction = null;
      this.onDragEnd?.();
      this.onDragFinish?.();
    }
  };

  /**
   * 拖拽开始
   */
  private onDragStart(): void {
    log.showInfo('onDragStart');
    this.dragParams?.onDragStart?.();
  }

  /**
   * 拖拽结束
   */
  private onDragEnd(): void {
    log.showInfo('onDragEnd');
    this.dragParams?.onDragEnd?.();
  }

  /**
   * 拖拽异常结束
   */
  private onDragCancel(): void {
    log.showInfo('onDragCancel');
    this.dragParams?.onDragCancel?.();
  }

  /**
   * 拖拽结束或者异常结束后回调
   */
  private onDragFinish(): void {
    log.showInfo('onDragFinish');
    this.dragParams?.onDragFinish?.();
  }
}

export class GatherAnimateItem {
  public parentId: string = '';
  public width: number = 0;
  public height: number = 0;
  public image?: image.PixelMap;
  public position: Position = { x: 0, y: 0 };
  public scale: number = 1;
  public zIndex?: number;
  public radius: number = 0;
}

export class GatherAnimateTarget {
  public parentId: string = '';
  public scale: number = 1;
  public startPosition: Position = { x: 0, y: 0 };
  public endPosition: Position = { x: 0, y: 0 };
  public zIndex?: number;
  public delay?: number;
  public animationType?: number;
}

export type doGatherAnimateType = (gatherAnimateTargetList: GatherAnimateTarget[]) => Promise<boolean>;

export type doDropAnimateType =
  (gatherAnimateTargetList: GatherAnimateTarget[], onItemFinish: (itemKey: string) => void) => Promise<boolean>;

export type DoDropToFolderAnimateType = (
  gatherAnimateTargetList: GatherAnimateTarget[],
  onItemFinish: (itemKey: string) => void
  ) => Promise<boolean>;


export type cancelAnimationType = () => void;

export type hideAnimationItemType = () => void;

export type updateAnimationTargetType = (position: Position) => void;

export type preLoadAnimationViewType = (gatherAnimateTargetList: GatherAnimateItem[]) => void;

export interface FolderInfo {
  isOpened: boolean;
  pageIndexInFolder: number;
  lastOpenedFolderItemInfo: GridLayoutItemInfo;
  lastOpenedFolderUniqueId: string;
}
export interface TouchPos {
  localX: number;
  localY: number;
  globalX: number;
  globalY: number;
}

/**
 * 落位进文件夹动效类型
 * @param FADE_GATHER 带透明度汇聚
 * @param GATHER 不带透明度汇聚
 * @param DROP 不带透明度落位文件夹
 * @param FADE_DROP 带透明度落位文件夹
 * @param REVERT_FADE_DROP 反复透明度变化落位文件夹
 */
export enum AnimationType {
  FADE_GATHER = 0,
  GATHER = 1,
  DROP = 2,
  FADE_DROP = 3,
  REVERT_FADE_DROP = 4,
}