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
import type NtfMgr from '@ohos.notificationManager';
import { SingletonHelper, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/commonconstants';
import type { LiveViewData } from '../data/LiveViewData';
import type { BaseDataParser } from './interface/BaseDataParser';
import { SystemDataParser } from './local/SystemDataParser';
import { OtherDataParser } from './other/OtherDataParser';
import transResToPicHelper from './utils/TransResToPicHelper';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'DataParserController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况窗数据解析控制器,根据实况数据的类型将解析任务分发到对应本地、三方应用数据解析器
 */
class DataParserController {
  // 数据处理器责任链头
  private headParser: BaseDataParser<LiveViewData>;

  constructor() {
    this.init();
  }

  /**
   * 数据解析入口函数
   * @param request 实况原数据
   * @returns 返回解析的实况窗数据
   */
  parseData(request?: NtfMgr.NotificationRequest): LiveViewData | undefined {
    if (CommonUtils.isInvalid(request) || CommonUtils.isInvalid(request.hashCode)) {
      log.showError('parseData request in invalid');
      return undefined;
    }
    log.showDebug('begin parseData');
    transResToPicHelper.start(request?.creatorBundleName);
    // 将数据解析任务交给解析器责任链头结点
    let res = this.headParser.parse(request);
    transResToPicHelper.end();
    return res;
  }

  /**
   * 初始化责任链
   */
  private init(): void {
    log.showInfo('begin init');
    this.headParser = new SystemDataParser();
    this.headParser.setNextParser(new OtherDataParser());
  }
}

let dataParserController = SingletonHelper.getInstance(DataParserController, TAG);

export default dataParserController as DataParserController;