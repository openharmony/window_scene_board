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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import type { IParser } from './IParser';
import type { IResult } from './IResult';
import { ParseResultType } from './IResult';

const TAG = 'ParserManager';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 数据解析器链条
 */
class ParserChain<P, T extends IResult> implements IParser<P, T> {
  /**
   * 接力解析器
   */
  nextParser?: ParserChain<P, T>;

  /**
   * 自身数据解析器
   */
  selfRealParser?: IParser<P, T>;

  /**
   * 解析数据
   * 复写IParser
   *
   * @param oriData 原数据
   * @param result 现有结果数据
   * @returns 解析结果
   */
  parse(oriData: P, result?: T): T | undefined {
    let selfResult = this.selfRealParser?.parse(oriData, result);

    // 匹配则终止向下解析
    let isMatch = (selfResult?.resultType ?? ParseResultType.MISS) === ParseResultType.MATCH;
    if (isMatch) {
      return selfResult;
    }

    // 继续向下解析
    return this.nextParser?.parse(oriData, selfResult);
  }
}

/**
 * 数据解析管理器
 * <P>原数据类型
 * <T>结果数据类型
 */
export class ParserController<P, T extends IResult> {
  /**
   * 解析器取名
   */
  private parserName?: string;

  /**
   * 数据解析器链条头
   */
  private oriParserChain?: ParserChain<P, T>;

  /**
   * 当前解析器
   */
  private curParserChain?: ParserChain<P, T>;

  /**
   * 构造
   *
   * @param parserName 解析器名
   */
  constructor(parserName?: string) {
    this.parserName = parserName;
  }

  /**
   * 添加数据解析器
   *
   * @param parser 数据解析器
   * @returns 链式
   */
  addParser(parser: IParser<P, T>): ParserController<P, T> {
    if (CommonUtils.isInvalid(parser)) {
      log.showWarn('addParser parser is invalid: ' + this.parserName);
      return this;
    }

    // 封装链条
    let parserChain: ParserChain<P, T> = new ParserChain();
    parserChain.selfRealParser = parser;

    // 起始链条
    if (CommonUtils.isInvalid(this.oriParserChain)) {
      this.oriParserChain = parserChain;
      this.curParserChain = parserChain;
      return this;
    }

    // 拼接链条
    if (!CommonUtils.isInvalid(this.curParserChain)) {
      this.curParserChain.nextParser = parserChain;
    }
    this.curParserChain = parserChain;
    return this;
  }

  /**
   * 开始解析数据
   *
   * @param oriData 原数据
   * @returns 结果数据
   */
  parse(oriData: P): T | undefined {
    return this.oriParserChain?.parse(oriData);
  }
}