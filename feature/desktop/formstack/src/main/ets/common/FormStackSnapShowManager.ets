/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { image } from '@kit.ImageKit';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { FormCommonUtil, GridLayoutItemInfo } from '@ohos/launchercommon';
import { FormViewModel } from '@ohos/form/src/main/ets/default/viewmodel/FormViewModel';
import { FormStackSnapCommonData } from './FormStackSnapCommonData';
import { FormStackConstants } from './FormStackConstants';
import { FormStackUtil } from './FormStackUtil';

const TAG: string = 'FormStackSnapShowManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackSnapShowManager {
  public static mInstance: FormStackSnapShowManager;
  public coverImagePixel?: image.PixelMap;
  public dropItemKey: string = '';
  private isSnapViewShow: boolean = false;

  public static getInstance(): FormStackSnapShowManager {
    if (!FormStackSnapShowManager.mInstance) {
      FormStackSnapShowManager.mInstance = new FormStackSnapShowManager();
    }

    return FormStackSnapShowManager.mInstance;
  }

  /**
   * 通知堆叠遮罩截图显示/取消显示
   * @param isShow 显示/取消显示
   * @param snapFormId 遮罩卡片组件ID
   * @param dimension 遮罩卡片尺寸类型
   * @param endLayoutInfo 显示遮罩的目标位置元素（卡片或者堆叠）
   */
  public notifyShowSnapImgMsg(isShow: boolean, snapFormId: string, dimension: number,
                            endLayoutInfo?: GridLayoutItemInfo): void {
    log.showWarn(`notify show snap img, isShow: ${isShow}, snapFormId: ${snapFormId}, dimension: ${dimension}.`);
    if (isShow && AppStorage.get('isDeskSwipe')) {
      // 桌面滑动过程中不通知截图遮罩显示
      log.showWarn('do not notify snap view show, currently in GridSwiper Gesture!');
      return;
    }
    this.isSnapViewShow = isShow;
    const borderRadius: number = FormViewModel.getInstance().getFormStyleConfig().getFormBorderRadius(dimension);
    const commonData: FormStackSnapCommonData | undefined = isShow ?
      FormStackSnapCommonData.createCommonData(snapFormId, borderRadius, endLayoutInfo) : undefined;
    GlobalContext.getContext().eventHub.emit(FormStackConstants.FORM_STACK_SNAP_SHOW_MSG, isShow, commonData);
  }

  /**
   * 外部因素导致截图需要中断显示，如桌面滑动
   */
  public cancelSnapViewShow(): void {
    if (this.isSnapViewShow) {
      this.isSnapViewShow = false;
      log.showWarn('cancel snap view show by exclusive operation!');
      GlobalContext.getContext().eventHub.emit(FormStackConstants.FORM_STACK_SNAP_SHOW_MSG, false);
    }
  }

  public async createCoverImgPixelMap(dropImage: image.PixelMap, itemKey: string): Promise<void> {
    if (!FormStackUtil.isValidImage(dropImage) || CheckEmptyUtils.checkStrIsEmpty(itemKey)) {
      log.showInfo('dropImage invalid or itemKey empty, create cover image pixelMap fail!');
      return;
    }

    let srcImageStr: string = await FormCommonUtil.convertPixelMap2String(dropImage);
    if (CheckEmptyUtils.checkStrIsEmpty(srcImageStr)) {
      log.showError('drop item image convert string invalid!');
      return;
    }

    this.coverImagePixel = await FormCommonUtil.convertString2PixelMap(srcImageStr);
    if (!FormStackUtil.isValidImage(this.coverImagePixel)) {
      log.showError('string convert cover image pixelMap invalid!');
      return;
    }

    log.showInfo('succeeded in creating pixmap.');
    this.dropItemKey = itemKey;
    setTimeout(() => {
      this.releaseCoverImage();
    }, FormStackConstants.FORM_STACK_SNAP_VIEW_DISAPPEAR_DELAY);
  }

  public releaseCoverImage(): void {
    if (CheckEmptyUtils.checkStrIsEmpty(this.dropItemKey)) {
      // 无需冗余释放
      return;
    }

    log.showWarn('release formstack cover image.');
    this.dropItemKey = '';
    FormStackUtil.releasePixelMap(this.coverImagePixel);
    this.coverImagePixel = undefined;
  }
}

export const formStackSnapShowManager = FormStackSnapShowManager.getInstance();