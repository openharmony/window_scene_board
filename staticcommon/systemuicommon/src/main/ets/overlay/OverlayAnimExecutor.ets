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
import { BorderRadiuses } from '@ohos.arkui.node';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { RectInfo } from '@ohos/basicutils';

declare type Length = number | string;

const TAG = 'OverlayAnimExecutor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/** 一镜到底步骤枚举 */
export enum OverlayAnimStepEnum {
  // 状态栏动效
  STATUS_BAR,
  // 卡片消失动效
  CARD_ALPHA,
  // 应用窗口布局动效
  SCENE_LAYOUT,
  // 应用窗口显现动效
  SCENE_ALPHA,
}

@Observed
export class OverlayAnimData {
  public tag: string = '';
  public isAnimating: boolean = false;
  public transY?: number;

  public bgWidth?: Length;
  public bgHeight?: Length;
  public bgOpacity?: number;
  public bgRadius?: BorderRadiuses;

  public contentWidth?: Length;
  public contentHeight?: Length;
  public contentOpacity?: number;

  public ntfPanelScale?: number;
  public ntfPanelOpacity?: number;

  public setTag(tag: string) {
    this.tag = tag;
  }

  public assignTo(data: OverlayAnimData): void {
    data.isAnimating = this.isAnimating;
    data.transY = this.transY;

    data.bgWidth = this.bgWidth;
    data.bgHeight = this.bgHeight;
    data.bgOpacity = this.bgOpacity;
    data.bgRadius = this.bgRadius;

    data.contentWidth = this.contentWidth;
    data.contentHeight = this.contentHeight;
    data.contentOpacity = this.contentOpacity;

    data.ntfPanelScale = this.ntfPanelScale;
    data.ntfPanelOpacity = this.ntfPanelOpacity;
  }

  public reset(): void {
    this.isAnimating = false;
    this.transY = undefined;

    this.bgWidth = undefined;
    this.bgHeight = undefined;
    this.bgOpacity = undefined;
    this.bgRadius = undefined;

    this.contentWidth = undefined;
    this.contentHeight = undefined;
    this.contentOpacity = undefined;

    this.ntfPanelScale = undefined;
    this.ntfPanelOpacity = undefined;
  }

  public toStr(): string {
    const lst: string[] = []
    lst.push('isAnimating ' + (this.isAnimating ?? ''));
    lst.push('bgWidth ' + (this.bgWidth ?? ''));
    lst.push('bgHeight ' + (this.bgHeight ?? ''));
    lst.push('bgOpacity ' + (this.bgOpacity ?? ''));
    lst.push('bgRadius ' + (this.bgRadius ?
      `${this.bgRadius.topLeft},${this.bgRadius.topRight},${this.bgRadius.bottomLeft},${this.bgRadius.bottomRight}` :
      ''));
    lst.push('contentWidth ' + (this.contentWidth ?? ''));
    lst.push('contentHeight ' + (this.contentHeight ?? ''));
    lst.push('contentOpacity ' + (this.contentOpacity ?? ''));
    lst.push('ntfPanelScale ' + (this.ntfPanelScale ?? ''));
    lst.push('ntfPanelOpacity ' + (this.ntfPanelOpacity ?? ''));
    return lst.join(', ');
  }
}

export class OverlayAnimExecutor {
  private animDataSet?: Set<OverlayAnimData>;
  private beforeHandlers?: Set<() => void>;
  private afterHandlers?: Set<() => void>;
  private endPointHandlersMapping?: Map<OverlayAnimStepEnum, Set<() => void>>;
  private containerRect?: RectInfo;
  public addAnimData = (data: OverlayAnimData): void => {
    log.showInfo('AddAnimData. tag: %{public}s, isInit: %{public}s', data.tag, this.animDataSet !== undefined);
    this.animDataSet?.add(data);
  }

  public addBeforeHandler(callback: () => void, tag?: string): void {
    this.addHandler(callback, 'Before', this.beforeHandlers, tag);
  }

  public addAfterHandler(callback: () => void, tag?: string): void {
    this.addHandler(callback, 'After', this.afterHandlers, tag);
  }

  public addAnimation(step: OverlayAnimStepEnum, event: (data: OverlayAnimData) => void, tag?: string): void {
    if (!this.endPointHandlersMapping) {
      log.showWarn('EndPointHandlersMapping not init.');
      return;
    }

    let handlers = this.endPointHandlersMapping.get(step);
    if (!handlers) {
      handlers = new Set();
      this.endPointHandlersMapping.set(step, handlers);
    }

    const desc = 'EndpointHandler_' + OverlayAnimStepEnum[step];
    this.addHandler(() => this.updateAnimData(event, desc), desc, handlers, tag);
  }

  private addHandler(handler: () => void, handlerName: string, handlerSet?: Set<() => void>, tag?: string): void {
    if (handlerSet) {
      handlerSet.add(handler);
      log.showInfo('AddHandler: %{public}s-%{public}s succeed. len: %{public}d.', handlerName, tag, handlerSet.size);
    } else {
      log.showInfo('AddHandler: %{public}s-%{public}s to not initialized set.', handlerName, tag);
    }
  }

  public init(animData?: OverlayAnimData[]): void {
    this.animDataSet = new Set();
    this.beforeHandlers = new Set();
    this.afterHandlers = new Set();
    this.endPointHandlersMapping = new Map();
    this.containerRect = undefined;
    animData && animData.forEach(this.addAnimData);
  }

  public assignAnimData(newState: OverlayAnimData, desc?: string): void {
    log.showInfo('AssignAnimData for %{public}s', desc);
    this.doUpdateAnimData((it: OverlayAnimData) => newState.assignTo(it));
  }

  public updateAnimData(updater: (data: OverlayAnimData) => void, desc?: string): void {
    log.showInfo('UpdateAnimData for %{public}s', desc);
    this.doUpdateAnimData(updater);
  }

  private doUpdateAnimData(updater: (data: OverlayAnimData) => void): void {
    if (this.animDataSet && this.animDataSet.size > 0) {
      log.showInfo('DoUpdateAnimData. len is %{public}d', this.animDataSet?.size);
      this.animDataSet.forEach((data: OverlayAnimData) => {
        const before = data.toStr();
        updater(data);
        const after = data.toStr();
        if (before !== after) {
          log.showInfo('Update %{public}s to %{public}s', data.tag, after)
        }
      });
    } else {
      log.showWarn('DoUpdateAnimData for empty anim data.');
    }
  }

  public calcToCenterTransYByVp(screenHeightPx: number, rect: RectInfo): number {
    const rectClipByList = this.calcRectClipByList(rect);
    const rectTop = rectClipByList?.top ?? 0;
    const rectBtm = rectClipByList?.bottom ?? 0;
    return (px2vp(screenHeightPx) - rectTop - rectBtm) / 2;
  }

  public getRectClipByList(cardPosition?: RectInfo): RectInfo | undefined {
    return this.calcRectClipByList(cardPosition);
  }

  private calcRectClipByList(pos?: RectInfo): RectInfo | undefined {
    if (pos && this.containerRect) {
      const cardTop = pos?.top ?? 0;
      const cardBtm = pos?.bottom ?? 0;
      const top = Math.max(this.containerRect?.top ?? cardTop, cardTop);
      const btm = Math.min(this.containerRect?.bottom ?? cardBtm, cardBtm);
      log.showInfo('CalcRectClipByList (%{public}d, %{public}d), (%{public}d, %{public}d), %{public}d',
        cardTop, cardBtm, top, btm, btm - top);
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = pos.left;
      rectInfo.top = top;
      rectInfo.bottom = btm;
      rectInfo.right = pos.right;
      rectInfo.setWidth(pos.right - pos.left);
      rectInfo.setHeight(btm - top);
      return rectInfo;
    } else {
      return pos;
    }
  }

  public handleBefore(): void {
    this.doHandle('Before', this.beforeHandlers);
  }

  public handleAfter(): void {
    this.doHandle('After', this.afterHandlers);
    this.doUpdateAnimData((it) => it.reset());
    this.animDataSet = undefined;
  }

  public handleEndPoint(step: OverlayAnimStepEnum): void {
    this.doHandle('HandleEndPoint ' + OverlayAnimStepEnum[step], this.endPointHandlersMapping?.get(step));
  }

  private doHandle(tag: string, callBacks?: Set<() => void>): void {
    if (!callBacks || callBacks.size === 0) {
      log.showWarn('%{public}s at empty handler.', tag);
      return;
    }
    log.showInfo('Handle %{public}s, handler len: %{public}d', tag, callBacks?.size);
    for (let callback of callBacks) {
      try {
        callback();
      } catch (err) {
        log.showError('%{public}s err: %{public}s', tag, (err as Error)?.message);
      }
    }
  }

  public setContainerRect(rect?: RectInfo): void {
    this.containerRect = rect;
  }

  public getContainerRect(): RectInfo | undefined {
    return this.containerRect;
  }
}

export class OverlayAnimExecutors {
  private static HOLDER?: OverlayAnimExecutor;

  public static getLastOrCreateExecutor(): OverlayAnimExecutor {
    if (OverlayAnimExecutors.HOLDER === undefined) {
      log.showInfo('GetLastOrCreateExecutor. create new executor.');
      OverlayAnimExecutors.HOLDER = new OverlayAnimExecutor();
    }
    return OverlayAnimExecutors.HOLDER;
  }

  public static popExecutor(): OverlayAnimExecutor {
    if (OverlayAnimExecutors.HOLDER) {
      const ret = OverlayAnimExecutors.HOLDER;
      OverlayAnimExecutors.HOLDER = undefined;
      return ret;
    }
    log.showWarn('PopExecutor return undefined.');
    return new OverlayAnimExecutor();
  }

  public static safeRemove(instance: OverlayAnimExecutor): void {
    log.showInfo('SafeRemove. HOLDER === instance is %{public}s', OverlayAnimExecutors.HOLDER === instance);
    if (OverlayAnimExecutors.HOLDER === instance) {
      OverlayAnimExecutors.HOLDER = undefined;
    }
  }
}