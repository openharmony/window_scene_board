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

import curves from '@ohos.curves';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { ToggleEditViewData } from './ToggleEditViewData';
import { SysApiWrapper } from '../common/SysApiWrapper';
import StyleConfiguration from '@ohos/systemuicommon/src/main/ets/template/common/StyleConfiguration';
import { TOGGLE_EDIT_LIBRARY_HEIGHT } from '../common/Constants';

const TAG = 'IotEditViewModel';
const log = LogHelper.getLogHelper(LogDomain.CC, TAG);
const MAX_SCROLL_HEIGHT: string | number = 10000;
const IOT_TOP_MARGIN: number = 21;
const QUICK_TOGGLE_TOP_MARGIN: number = 14;
// IOT编辑预览区被撑起时底部边距，390+13-64
const IOT_BOTTOM_MARGIN: number = 339;

export class IotEditViewModel {
  public scroller: Scroller = new Scroller();
  private viewData: ToggleEditViewData;
  private showDoubleColumn: boolean;
  private iotMessageHandlers: Map<string, (data: object) => void> = new Map();
  private isIotAppeared: boolean = false;
  private isIotEntered: boolean = false;
  private _dragIotCard: boolean = false;
  private _iotProxy?: UIExtensionProxy | undefined;
  private _isIotEdited: boolean = false;
  private _needDelayReleaseIot: boolean = false;
  private onAboutToAppearHandler: (() => void) | undefined = undefined;
  private quickIotEdit: Function = () => {
  };
  private scrollToWithBlur: Function = (y: number) => {
  };
  private showToast: Function = (msg: ResourceStr) => {
  };

  constructor(viewData: ToggleEditViewData, showDoubleColumn: boolean) {
    this.viewData = viewData;
    this.showDoubleColumn = showDoubleColumn;
    this.initIotMessageHandlers();
  }

  public get dragIotCard(): boolean {
    return this._dragIotCard;
  }

  public get iotProxy(): UIExtensionProxy | undefined {
    return this._iotProxy;
  }

  public get isIotEdited(): boolean {
    return this._isIotEdited;
  }

  public get needDelayReleaseIot(): boolean {
    return this._needDelayReleaseIot;
  }

  public initViewModelFunc(quickIotEdit: Function, scrollToWithBlur: Function, showToast: Function): void {
    this.quickIotEdit = quickIotEdit;
    this.scrollToWithBlur = scrollToWithBlur;
    this.showToast = showToast;
  }

  public onIotRemoteReady = (proxy?: UIExtensionProxy): void => {
    log.showInfo(`onIotRemoteReady ${proxy}`);
    this._iotProxy = proxy;
    proxy?.send({ 'method': 'jumpToIotEdit' });
  }
  public onIotMessage = (data?: object): void => {
    if (!data) {
      log.error(`invalid iot message`);
      return;
    }
    let method: string = data['method'] as string ?? '';
    log.showInfo(`onIotMessage ${method}`);
    let handler = this.iotMessageHandlers.get(method);
    if (handler) {
      handler(data);
    } else {
      log.warn(`unknown method: ${method}`);
    }
  }

  /**
   * IOT交互集合
   */
  private initIotMessageHandlers() {
    this.iotMessageHandlers.set('PreloadShowSheet', this.preloadIotLibrary);
    this.iotMessageHandlers.set('ShowSheet', this.expandIotEdit);
    this.iotMessageHandlers.set('setIotAbilityHeight', this.updateIotHeight);
    this.iotMessageHandlers.set('iotIsEdit', this.changeIotEditStatus);
    this.iotMessageHandlers.set('closeControlCenter', this.onReceiveCloseControlCenter);
    this.iotMessageHandlers.set('showToast', this.showIotToast);
    this.iotMessageHandlers.set('editAboutToAppear', this.onIotEditAboutToAppear);
    this.iotMessageHandlers.set('dragIotCard', this.changeScrollStatus);
  }

  private changeScrollStatus = (data: object): void => {
    this._dragIotCard = data?.['param'] !== 0;
  }
  private changeIotEditStatus = (data: object): void => {
    this._isIotEdited = data?.['param'] !== 0;
  }
  private onReceiveCloseControlCenter = (data: object): void => {
    this._needDelayReleaseIot = true;
    this.quickIotEdit();
  }
  private showIotToast = (data: object): void => {
    let msg = String(data?.['message']);
    this.showToast(msg);
  }
  private onIotEditAboutToAppear = (data: object): void => {
    this.isIotAppeared = true;
    if (this.onAboutToAppearHandler !== undefined) {
      this.onAboutToAppearHandler();
      this.onAboutToAppearHandler = undefined;
    }
  }
  private updateIotHeight = (data: object): void => {
    let newHeight: number = data?.['height'] ?? 0;
    if (newHeight === this.viewData.iotPageHeight) {
      return;
    }
    SysApiWrapper.animateTo({
      duration: 450,
      curve: curves.springCurve(0, 1, 228, 28),
    }, () => {
      this.viewData.iotPageHeight = newHeight;
      if (!this.viewData.loadIotLibrary) {
        return;
      }
      if (!this.showDoubleColumn) {
        this.scroller.scrollTo({ xOffset: 0, yOffset: this.getIotPreviewScrollOffset() });
        return;
      }
      let heightDiff: number = newHeight - this.viewData.scrollHeight - 16;
      if (heightDiff > 0) {
        this.scroller.scrollTo({ xOffset: 0, yOffset: this.getIotStartY() + heightDiff });
      }
    });
  }
  private preloadIotLibrary = (data: object): void => {
    TraceUtil.startTrace(DomainName.CC, 'preloadIotLibrary');
    this.viewData.loadIotLibrary = true;
    if (data?.['showFullPage']) {
      this.viewData.iotPageHeight = this.viewData.scrollHeight;
    }
  }
  private expandIotEdit = (data: object): void => {
    TraceUtil.endTrace(DomainName.CC, 'preloadIotLibrary');
    TraceUtil.startTrace(DomainName.CC, 'expandIotEdit');
    SysApiWrapper.animateTo({
      duration: 450,
      curve: curves.springCurve(0, 1, 228, 28),
      onFinish: () => {
        TraceUtil.endTrace(DomainName.CC, 'expandIotEdit');
      }
    }, () => {
      this.viewData.showIotLibrary = true;
      this.viewData.iotLibraryTrans = 0;
      if (!this.showDoubleColumn) {
        // 滚动到底部，可打断；scrollEdge方法无法打断
        this.scrollToWithBlur(this.getIotPreviewScrollOffset());
        return;
      }
      let iotStartY: number = this.getIotStartY() + IOT_TOP_MARGIN;
      if (this.scroller.currentOffset().yOffset < iotStartY) {
        this.scrollToWithBlur(iotStartY);
      }
    })
  }

  private getIotPreviewScrollOffset(): number {
    if (this.viewData.iotPageHeight - IOT_TOP_MARGIN + IOT_BOTTOM_MARGIN < this.viewData.scrollHeight) {
      return this.getIotStartY() + IOT_TOP_MARGIN;
    }
    return this.getIotStartY() + this.viewData.iotPageHeight + IOT_BOTTOM_MARGIN - this.viewData.scrollHeight;
  }

  private getIotStartY(): number {
    return this.viewData.editPreviewPanelHeight + this.viewData.editTopPreviewPanelHeight + QUICK_TOGGLE_TOP_MARGIN;
  }

  public collapseIotEdit(): void {
    TraceUtil.startTrace(DomainName.CC, 'collapseIotEdit');
    this._iotProxy?.send({ 'method': 'backToEditHome' });
    SysApiWrapper.animateTo({
      duration: 450,
      curve: curves.springCurve(0, 1, 228, 28),
      onFinish: () => {
        TraceUtil.endTrace(DomainName.CC, 'collapseIotEdit');
        this.viewData.loadIotLibrary = false;
      }
    }, () => {
      this.viewData.showIotLibrary = false;
      this.viewData.iotLibraryTrans = TOGGLE_EDIT_LIBRARY_HEIGHT;
      this.scrollToWithBlur(MAX_SCROLL_HEIGHT as number);
    });
  }

  public notifyIot(): void {
    if (!this.isIotAppeared) {
      // 如果服务未启动，则等待服务启动之后再执行该回调
      this.onAboutToAppearHandler = () => {
        this.iotStartToEnter();
      };
    } else {
      this.iotStartToEnter();
    }
  }

  private iotStartToEnter() {
    log.showInfo(`iotStartToEnter : entered:${this.isIotEntered},appeared:${this.isIotAppeared}`);
    if (this.isIotEntered) {
      return;
    }
    if (this.isIotAppeared) {
      this.isIotEntered = true;
      let fontResourceColor = StyleConfiguration.getToggleLabelStyle().labelColor;
      if (typeof fontResourceColor !== 'number' && typeof fontResourceColor !== 'string') {
        let fontColor = fontResourceColor as Resource
        try {
          let color = GlobalContext.getContext().resourceManager.getColorSync(fontColor.id);
          this._iotProxy?.send({ 'method': 'textColor', 'param': color });
        } catch (err) {
          log.error(`getColorSync failed: ${err.message}`);
        }
      }
      // 通知IOT开始做边框动画
      this._iotProxy?.send({ 'method': 'scrollEndShowBorder' });
    }
  }
}