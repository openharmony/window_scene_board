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
import type image from '@ohos.multimedia.image';
import { SingletonHelper, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/commonconstants';
import { ResUtils } from '@ohos/windowscene';
import type NtfMgr from '@ohos.notificationManager';
import { ParseConfigUtils } from '@ohos/systemuiutils/src/main/ets/plugin/ParseConfigUtils';
import { RichText } from '../../data/template/LiveBaseTemplate';
import type { LiveBaseTemplate } from '../../data/template/LiveBaseTemplate';
import { LiveType } from '../../common/LiveConstants';
import type { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'CommonUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况数据解析的工具类
 */
class ParseUtils {
  /**
   * 将字符串转换为富文本
   *
   * @param text
   * @param maxLen 文本最大长度
   * @returns
   */
  parseRichText(text: string, maxLen: number): RichText[] | undefined {
    let richTextArr: RichText[] = new Array<RichText>();
    let jsonArray;
    try {
      jsonArray = JSON.parse(text);
    } catch (err) {
      log.error('json parse error');
    }
    if (!Array.isArray(jsonArray)) {
      return richTextArr;
    }
    let totalTextLen = 0;
    for (const data of jsonArray) {
      let richText = new RichText();
      if (totalTextLen + (data.text as string)?.length >= maxLen) {
        richText.text = data.text.substring(0, maxLen - totalTextLen);
        richText.oriTextColor = data.textColor;
        richTextArr.push(richText);
        break;
      }
      richText.text = data.text;
      richText.oriTextColor = data.textColor;
      richTextArr.push(richText);
      totalTextLen += (data.text as string)?.length;
    }
    return richTextArr;
  }

  /**
   * 设置实况窗需要显示的appIcon,
   * smallIcon存在时总是代替appIcon
   *
   * @param request
   * @param newData
   */
  setAppIcon(request: NtfMgr.NotificationRequest, newData: LiveBaseTemplate): void {
    // 系统实况通知，允许用smallIcon替代应用图标
    let smallIcon: image.PixelMap | undefined = request?.smallIcon;
    let isSys = newData?.getLiveType() === LiveType.TYPE_SYSTEM;
    if (isSys && !CommonUtils.isInvalid(smallIcon)) {
      newData.setAppIcon(smallIcon);
      return;
    }
    let creatorBundleName = request?.creatorBundleName;
    let creatorUserId = request?.creatorUserId;
    ParseConfigUtils.getBundleInfo(creatorBundleName, creatorUserId).then((info) => {
      let appIconRes = info?.appInfo?.iconResource;
      ResUtils.getOutDrawableDescriptor(appIconRes).then((appIcon: DrawableDescriptor) => {
        newData.setAppIconRes(appIcon);
      });
    });
  }
}

let parseUtils = SingletonHelper.getInstance(ParseUtils, TAG);

export default parseUtils as ParseUtils;