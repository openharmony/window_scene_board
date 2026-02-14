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
import { DomainName, LogDomain, LogHelper, SingleBase, singleManager } from '@ohos/basicutils';
import { TraceUtil, SingletonHelper } from '@ohos/basicutils';
import { RectangularCoordinates } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
    ForceType,
    GravityAnimationAlgorithm, GravityAnimationParameter
} from '../algorithm/algorithm/GravityAnimationAlgorithm';
import { GravityAnimationConfig } from '../algorithm/config/GravityAnimationConfig';
import { GravityAnimationDebug } from '../algorithm/debug/GravityAnimationDebug';
import { gravityAnimationListenerManager } from './GravityAnimationListener';
import { SwiperLoadData } from '@ohos/swiperdata';
import { desktopUtil } from '@ohos/componenthelper';

const TAG = 'GravityAnimationManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 特殊的组件所在Page，区别于PageIndex
 */
export enum GravityAnimationPage {
  FOREVER_TRIGGER = -1,
}

enum ComponentStatus {
  DEACTIVED = 0,
  ACTIVE,
}

/**
 * 引力动效组件类
 * 受引力动效影响的组件，需要集成此类，注册到引力动效管理类中
 *
 * @since 2024/04/20
 */
export class GravityAnimationComponent {
  private pageIndex: number = -1;
  /* 当前元素中心点，单位vp */
  private center: RectangularCoordinates.Point = { x: 0, y: 0 };
  /* 当前元素偏离中心点的偏移量，单位vp。设计这个参数的目的是因为当前调用者大都使用转场动效，更贴合offset的方案做临时偏移 */
  private offset: RectangularCoordinates.Point = { x: 0, y: 0 };
  /* 当前元素在桌面的行列 */
  private row: number = -1;
  private column: number = -1;
  private width: number = -1;
  private height: number = -1;
  private status: ComponentStatus = ComponentStatus.ACTIVE;
  private startGravityCallback: (param: GravityAnimationParameter) => void;
  private forceUpdateLayoutCallback?: () => void;

  /**
   * 创建引力动效组件
   *
   * @param startGravityCallback      执行引力动效的回调函数
   * @param forceUpdateLayoutCallback 强制刷新布局回调，解决部分业务场景无法感知布局已经刷新的问题时传入
   */
  constructor(startGravityCallback: (param: GravityAnimationParameter) => void,
              forceUpdateLayoutCallback?: () => void) {
    this.startGravityCallback = startGravityCallback;
    this.forceUpdateLayoutCallback = forceUpdateLayoutCallback;
  }

  /**
   * 判断两个组件是否重叠
   * 考虑到图标范围较大，使用坐标判断误差，使用的是行列判断
   *
   * @param other 需要比较的组件
   * @returns 校验结果
   */
  public equal(other: GravityAnimationComponent): boolean {
    return this.pageIndex === other.pageIndex && this.column === other.column && this.row === other.row;
  }

  /**
   * 判断两个组件的先后关系，用于比较
   *
   * @param other 需要比较的组件
   * @returns 校验结果，:< 0：当前比比较组件靠前，0：当前和比较组件一致；> 0：当前比比较组件靠后
   */
  public compare(other: GravityAnimationComponent): number {
    if (this.row < other.row) {
      return -1;
    } else if (this.row === other.row) {
      return this.column - other.column;
    } else {
      return 1;
    }
  }

  /**
   * 组件的描述字符串
   *
   * @returns 描述内容
   */
  public toString(): string {
    /* 本函数内尽量不要调用其他函数，避免引起递归循环 */
    return (this.status === ComponentStatus.ACTIVE ? 'ACTIVE' : 'DEACTIVED') +
      '-COMPONENT [P:' + this.pageIndex + ',R:' + this.row + ',C:' + this.column +
      ',X:' + this.center.x + '+' + this.offset.x +
      ',Y:' + this.center.y + '+' + this.offset.y +
      ',W:' + this.width + ',H:' + this.height + ']';
  }

  /**
   * 强制刷新布局，解决某些业务不能准确知道自己位置的情况
   */
  public updateLayout(): void {
    if (this.forceUpdateLayoutCallback) {
      this.forceUpdateLayoutCallback();
    }
  }

  /**
   * 开始触发引力动效，执行业务模块注册的回调函数
   *
   * @param param 引力动效参数
   */
  public startGravity(param: GravityAnimationParameter): void {
    this.startGravityCallback(param);
  }

  /**
   * 设置当前组件的激活状态，未激活的组件不参与引力动效
   *
   * @param active 激活状态
   */
  public setActive(active: boolean): void {
    log.showInfo('SET %{public}s status -> %{public}s', this.toString(), (active ? 'ACTIVE' : 'DEACTIVED'));
    this.status = active ? ComponentStatus.ACTIVE : ComponentStatus.DEACTIVED;
  }

  /**
   * 设置当前组件的布局信息。
   *
   * @param pageIndex 页面索引。其中GravityAnimationPage.FOREVER_TRIGGER的页面会永远被触发动效
   * @param row 组件所在当前页的行号
   * @param column 组件所在当前页的列号
   * @param width 组件宽度（和列号一致单位）
   * @param height 组件高度（和行号一致单位）
   */
  public setLayoutInfo(pageIndex: number, row: number, column: number, width: number, height: number): void {
    log.showInfo('SET %{public}s layout -> [P:%{public}d,R:%{public}d,C:%{public}d,W:%{public}d,H:%{public}d]',
      this.toString(), pageIndex, row, column, width, height);
    this.pageIndex = pageIndex;
    this.row = row;
    this.column = column;
    this.width = width;
    this.height = height;
  }

  /**
   * 设置新的组件位置
   * 提供该接口的原因是有些特殊场景，如拖拽，会存在位置的变更
   *
   * @param x 组件中心点所在屏幕的横坐标vp
   * @param y 组件中心点所在屏幕的纵坐标vp
   */
  public setPosition(x: number, y: number): void {
    log.showInfo('SET %{public}s position -> [X:%{public}d,Y:%{public}d]', this.toString(), x, y);
    this.center.x = x;
    this.center.y = y;
    this.offset.x = 0;
    this.offset.y = 0;
  }

  /**
   * 设置新的组件临时偏移位置
   * 提供该接口的原因是有些特殊场景，如挤位，会存在位置的临时变更
   *
   * @param x 组件中心点所在屏幕的横坐标vp
   * @param y 组件中心点所在屏幕的纵坐标vp
   */
  public setOffset(x: number, y: number): void {
    this.offset.x = x;
    this.offset.y = y;
  }

  /**
   * 获取当前组件的横坐标，包括临时偏移
   *
   * @returns 横坐标vp值
   */
  public getX(): number {
    let x = this.center.x + this.offset.x;
    if (x < 0) {
      log.showWarn('INVALID %{public}s X', this.toString());
      return 0;
    }
    return x;
  }

  /**
   * 获取当前组件的纵坐标，包括临时偏移
   *
   * @returns 纵坐标vp值
   */
  public getY(): number {
    let y = this.center.y + this.offset.y;
    if (y < 0) {
      log.showWarn('INVALID %{public}s Y', this.toString());
      return 0;
    }
    return y;
  }


  /**
   * 获取当前组件的行索引
   *
   * @returns 行索引，从0开始
   */
  public getRow(): number {
    if (this.row < 0) {
      log.showWarn('INVALID %{public}s ROW', this.toString());
      return 0;
    }
    return this.row;
  }

  /**
   * 获取当前组件的列索引
   *
   * @returns 列索引，从0开始
   */
  public getCol(): number {
    if (this.column < 0) {
      log.showWarn('INVALID %{public}s COLUMN', this.toString());
      return 0;
    }
    return this.column;
  }

  /**
   * 获取当前组件的宽度
   *
   * @returns 宽度，单位是格数
   */
  public getWidth(): number {
    if (this.width < 0) {
      log.showWarn('INVALID %{public}s WIDTH', this.toString());
      return 0;
    }
    return this.width;
  }

  /**
   * 获取当前组件的高度
   *
   * @returns 高度，单位是格数
   */
  public getHeight(): number {
    if (this.height < 0) {
      log.showWarn('INVALID %{public}s HEIGHT', this.toString());
      return 0;
    }
    return this.height;
  }

  /**
   * 获取当前组件的Page索引
   *
   * @returns Page索引
   */
  public getPageIndex(): number {
    return this.pageIndex;
  }

  /**
   * 获取当前组件激活状态
   *
   * @returns 组件激活状态
   */
  public isActive(): boolean {
    return this.status === ComponentStatus.ACTIVE;
  }
}

/* 用于延迟引力动效 */
interface RunParameter {
  x: number,
  y: number,
  pageIndex: number,
  force: ForceType,
  area: number[],
}

/**
 * 引力动效管理类
 * 使用此类完成参与引力动效的注册管理、引力动效的触发等流程
 *
 * @since 2024/04/20
 */
export class GravityAnimationManager extends SingleBase {
  public static singleName: string = 'GravityAnimationManager';
  private pages: Map<number, GravityAnimationComponent[]> = new Map<number, GravityAnimationComponent[]>();

  static getInstance(): GravityAnimationManager {
    return gravityAnimationManager;
  }

  constructor() {
    super();
    GravityAnimationDebug.register();
  }

  private getNeighborPageMap(index: number): GravityAnimationComponent[] | undefined {
    if (index < 0) {
      return undefined;
    }
    if (!desktopUtil.isFoldExpandStatus()) {
      return undefined;
    }

    const neighborIndex = SwiperLoadData.getInstance().getNeighborSwiperKey(index);
    log.showDebug('target page %{public} has neighbor page %{public}', index, neighborIndex);
    return this.pages.get(neighborIndex);
  }

  /* 采用多维数据的原因是某些调用场景，希望获取原始page(GravityAnimationComponent[])，可以在此接触上直接push新元素。 */
  private getOrCreatePageMap(index: number, create: boolean, withNeighbor: boolean):
    (GravityAnimationComponent[] | undefined)[] {
    let page: GravityAnimationComponent[] | undefined = this.pages.get(index);
    if (!page && create) {
      page = [];
      this.pages.set(index, page);
    }
    let total: (GravityAnimationComponent[] | undefined)[] = [];
    total[0] = page;

    if (withNeighbor) {
      const neighborPage = this.getNeighborPageMap(index);
      total[1] = neighborPage;
    }

    return total;
  }

  private getComponentInPageMap(component: GravityAnimationComponent,
                                create: boolean): GravityAnimationComponent[] | undefined {
    return this.getOrCreatePageMap(component.getPageIndex(), create, false)[0];
  }

  private findComponentInPageMap(page: GravityAnimationComponent[], com: GravityAnimationComponent): number {
    /* 对引力动效来说，不关心元素的ID是不是重复，只关心坐标位置有没有重复 */
    return page.findIndex((item: GravityAnimationComponent) => {
      return item === com;
    });
  }

  private addComponentToPageMap(page: GravityAnimationComponent[], com: GravityAnimationComponent): void {
    let found = this.findComponentInPageMap(page, com);
    if (found > -1) {
      log.showWarn('find repeat %{public}s, let`s try to update its layout', page[found].toString());
      page[found].updateLayout();
      found = this.findComponentInPageMap(page, com);
      if (found > -1) {
        log.showWarn('remove repeat %{public}s, remain %{public}d components', page[found].toString(),
          page.length - 1);
        page.splice(found, 1);
      }
    }

    page.push(com);
    log.showInfo('add new %{public}s to page, total %{public}d components',
      com.toString(), page.length);
  }

  private removeComponentFromPageMap(page: GravityAnimationComponent[], com: GravityAnimationComponent): void {
    let found = this.findComponentInPageMap(page, com);
    if (found > -1) {
      log.showInfo('remove %{public}s from page, remain %{public}d components', page[found].toString(),
        page.length - 1);
      page.splice(found, 1);
      log.showInfo('delete index %{public}d, remain %{public}d components', found, page.length);
    } else {
      log.showWarn('%{public}s cannot find from all pages', com.toString());
    }
  }

  private generateParameters(algorithm: GravityAnimationAlgorithm, pages: (GravityAnimationComponent[] | undefined)[]):
    Map<GravityAnimationComponent, GravityAnimationParameter> {
    let componentsParams = new Map<GravityAnimationComponent, GravityAnimationParameter>();

    pages.forEach((page: GravityAnimationComponent[] | undefined) => {
      page?.forEach((item) => {
        if (!item.isActive()) {
          log.showDebug('component is not active: ', item.toString());
          return;
        }
        let param = algorithm.generateParameter(item.getX(), item.getY());
        log.showInfo('generate %{public}s with %{public}s', item.toString(), algorithm.parameterToString(param));
        if (param.effected) {
          componentsParams.set(item, param);
        }
      });
    })

    return componentsParams;
  }

  private generateTargetParameters(algorithm: GravityAnimationAlgorithm, pageIndex: number):
    Map<GravityAnimationComponent, GravityAnimationParameter> {
    let pages = this.getOrCreatePageMap(pageIndex, false, true);
    return this.generateParameters(algorithm, pages);
  }

  private generateForeverParameters(algorithm: GravityAnimationAlgorithm):
    Map<GravityAnimationComponent, GravityAnimationParameter> {
    return this.generateTargetParameters(algorithm, GravityAnimationPage.FOREVER_TRIGGER);
  }

  private adjustParameters(algorithm: GravityAnimationAlgorithm,
                           params: Map<GravityAnimationComponent, GravityAnimationParameter>): boolean {
    let array = Array.from(params.values());
    /* 因为最近元素不需要延迟，这里需要再刷新一轮时延参数 */
    return algorithm.adjustParameter(array);
  }

  private isLargeComponent(com: GravityAnimationComponent): boolean {
    return com.getWidth() > 1 || com.getHeight() > 1;
  }

  private drawComponent(page: string[][], com: GravityAnimationComponent, value: string): void {
    let maxRow = com.getRow() + com.getHeight();
    let maxCol = com.getCol() + com.getWidth();
    for (let i = com.getRow(); i < maxRow && i < page.length; i++) {
      for (let j = com.getCol(); j < maxCol && j < page[i].length; j++) {
        page[i][j] = value;
      }
    }
  }

  private notifyPreAnimation(pageIndex: number): void {
    let targetPages = this.getOrCreatePageMap(pageIndex, false, true);
    targetPages?.forEach((array: GravityAnimationComponent[] | undefined) => {
      array?.forEach((item: GravityAnimationComponent) => {
        item.updateLayout();
      })
    })
    let forever = this.getOrCreatePageMap(GravityAnimationPage.FOREVER_TRIGGER, false, false)[0];
    forever?.forEach((value: GravityAnimationComponent) => {
      value.updateLayout();
    })
  }

  private notifyStartAnimation(map: Map<GravityAnimationComponent, GravityAnimationParameter>): void {
    map.forEach((value: GravityAnimationParameter, key: GravityAnimationComponent) => {
      key.startGravity(value);
    });
  }

  private isSupport(): boolean {
    GravityAnimationConfig.initial();
    if (!GravityAnimationConfig.isEnable()) {
      log.showWarn('gravity animation has been disabled');
      return false;
    }

    return true;
  }

  /**
   * 注册组件到引力动效模块
   *
   * @param com 需要参与引力动效的组件
   */
  public addComponent(com: GravityAnimationComponent): void {
    if (!this.isSupport()) {
      return;
    }
    let page = this.getComponentInPageMap(com, true);
    if (page) {
      this.addComponentToPageMap(page, com);
    } else {
      log.showError('cannot find %{public}s in pages', com.toString());
    }
  }

  /**
   * 去注册组件到引力动效模块
   *
   * @param com 需要去注册引力动效的组件
   */
  public removeComponent(com: GravityAnimationComponent): void {
    if (!this.isSupport()) {
      return;
    }
    let page = this.getComponentInPageMap(com, false);
    if (page) {
      this.removeComponentFromPageMap(page, com);
      if (page.length == 0) {
        /* 删除后，后续代码请勿使用pageMap */
        this.pages.delete(com.getPageIndex());
      }
    }
  }

  /**
   * 启动运行引力动效
   *
   * @param pageIndex 当前page页索引
   * @param x 引力中心点所在屏幕的横坐标vp
   * @param y 引力中心点所在屏幕的纵坐标vp
   * @param force 引力方向
   * @param size  当前元素大小
   */
  public run(pageIndex: number, x: number, y: number, force: ForceType = ForceType.REPULSION,
             size: number[] = [1, 1]): void {
    if (!this.isSupport()) {
      return;
    }
    log.showInfo('gravity animation start, center [P:%{public}d, X:%{public}d, Y:%{public}d], force: %{public}s, ' +
      'size:[W:%{public}d, H:%{public}d]', pageIndex, x, y,
      force === ForceType.REPULSION ? 'REPULSION' : 'GRAVITATION', size[0], size[1]);

    TraceUtil.startTraceWithTaskId(DomainName.SCB, 'NotifyPreGravityAnimation', 1);
    /* 1. 预通知动效 */
    this.notifyPreAnimation(pageIndex);
    TraceUtil.endTraceWithTaskId(DomainName.SCB, 'NotifyPreGravityAnimation', 1);

    /* 2. 生成初始化的参数 */
    TraceUtil.startTraceWithTaskId(DomainName.SCB, 'GenerateGravityAnimation', 1);
    let algorithm = new GravityAnimationAlgorithm(x, y, force, size);
    let targetParams = this.generateTargetParameters(algorithm, pageIndex);
    let foreverParams = this.generateForeverParameters(algorithm)

    /* 3. 合并所有参数到同一map */
    targetParams.forEach((value: GravityAnimationParameter, key: GravityAnimationComponent) => {
      foreverParams.set(key, value);
    });

    /* 4. 调整参数 */
    let valid = this.adjustParameters(algorithm, foreverParams);
    TraceUtil.endTraceWithTaskId(DomainName.SCB, 'GenerateGravityAnimation', 1);

    if (valid) {
      /* 5. 触发动效 */
      this.notifyStartAnimation(foreverParams);
    } else {
      log.showWarn('some parameter invalid, recompense for notify right now');
      gravityAnimationListenerManager.notifyFinished();
    }

  }

  /**
   * 启动运行引力动效
   *
   * @param delay 延迟时间ms
   * @param pageIndex 当前page页索引
   * @param pos 引力中心点所在屏幕的坐标vp
   * @param force 引力方向
   * @param area  当前元素大小
   * @returns 定时器返回值
   */
  public runLater(delay: number, pageIndex: number, pos: number[], force: ForceType = ForceType.REPULSION,
                  area: number[] = [1, 1]): number | undefined {
    if (!this.isSupport()) {
      return undefined;
    }
    let para: RunParameter = {
      x: pos[0],
      y: pos[1],
      pageIndex: pageIndex,
      force: force,
      area: area,
    }

    return setTimeout(() => {
      GravityAnimationManager.getInstance()
        .run(para.pageIndex, para.x, para.y, para.force, para.area);
    }, delay);
  }

  /**
   * 告知引力动效模块动效结束
   *
   * @param param 引力动效回调传入的原始动效参数
   */
  public markFinish(param: GravityAnimationParameter): void {
    if (param.effected && param.isFarthest) {
      gravityAnimationListenerManager.notifyFinished();
    }
  }

  /**
   * 根据引力动效组件类map绘制维测字符串
   *
   * @param pageIndex 指定页
   * @returns  维测字符串
   */
  public showComponents(pageIndex?: number): string {
    let count: number = 0;

    this.pages.forEach((page) => { count += page.length });
    let total: string = count + ' COMPONENTS' + '\n';
    total += '------------------\n';
    this.pages.forEach((page, index) => {
      total += 'PAGE INDEX: ' + index + '\n';
      page.forEach((com) => { total += com.toString() + '\n' })
      total += '------------------\n';
    })

    return total;
  }

  /**
   * 根据引力动效组件类map绘制维测图形
   *
   * @param pageIndex 指定页
   * @returns  维测字符串
   */
  public drawLayouts(pageIndex?: number): string {
    const MAX_ROW = 16;
    const MAX_COL = 16;
    let total: string = this.pages.size + ' PAGES' + '\n';
    total += '------------------\n';
    this.pages.forEach((array, index) => {
      let page: string[][] = Array(MAX_ROW).fill(-1).map(() => Array(MAX_COL).fill(' '));
      array.forEach((item) => {
        if (item.getRow() >= MAX_ROW || item.getCol() >= MAX_COL) {
          log.showWarn('%{public}s exceed limits', item.toString());
          return;
        }
        this.drawComponent(page, item, this.isLargeComponent(item) ? 'C' : 'X');
      })

      total += 'PAGE INDEX: ' + index + '\n';
      page.forEach((row) => {
        total += '|' + row.join('') + '|\n'
      })
      total += '------------------\n';
    })

    return total;
  }

  /**
   * 获取指定页的引力动效组件类map，用于DT测试
   *
   * @param index 指定页
   * @returns 组件map
   */
  public getPageMap(index: number): GravityAnimationComponent[] | undefined {
    return this.getOrCreatePageMap(index, false, false)[0];
  }
}

export let gravityAnimationManager: GravityAnimationManager = SingletonHelper.getInstance(GravityAnimationManager, TAG);
/* 注册GravityAnimationManager类型到单例管理模块，同时注册当前模块创建的实例为第一个实例 */
singleManager.register(GravityAnimationManager, gravityAnimationManager);