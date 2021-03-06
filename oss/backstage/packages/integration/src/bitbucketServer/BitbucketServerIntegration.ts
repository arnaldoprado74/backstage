/*
 * Copyright 2020 The Backstage Authors
 *
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

import parseGitUrl from 'git-url-parse';
import { basicIntegrations, defaultScmResolveUrl } from '../helpers';
import { ScmIntegration, ScmIntegrationsFactory } from '../types';
import {
  BitbucketServerIntegrationConfig,
  readBitbucketServerIntegrationConfigs,
} from './config';

/**
 * A Bitbucket Server based integration.
 *
 * @public
 */
export class BitbucketServerIntegration implements ScmIntegration {
  static factory: ScmIntegrationsFactory<BitbucketServerIntegration> = ({
    config,
  }) => {
    const configs = readBitbucketServerIntegrationConfigs(
      config.getOptionalConfigArray('integrations.bitbucketServer') ?? [],
    );
    return basicIntegrations(
      configs.map(c => new BitbucketServerIntegration(c)),
      i => i.config.host,
    );
  };

  constructor(
    private readonly integrationConfig: BitbucketServerIntegrationConfig,
  ) {}

  get type(): string {
    return 'bitbucketServer';
  }

  get title(): string {
    return this.integrationConfig.host;
  }

  get config(): BitbucketServerIntegrationConfig {
    return this.integrationConfig;
  }

  resolveUrl(options: {
    url: string;
    base: string;
    lineNumber?: number;
  }): string {
    const resolved = defaultScmResolveUrl(options);

    // Bitbucket Server line numbers use the syntax #example.txt-42, rather than #L42
    if (options.lineNumber) {
      const url = new URL(resolved);

      const filename = url.pathname.split('/').slice(-1)[0];
      url.hash = `${filename}-${options.lineNumber}`;
      return url.toString();
    }

    return resolved;
  }

  resolveEditUrl(url: string): string {
    const urlData = parseGitUrl(url);
    const editUrl = new URL(url);

    editUrl.searchParams.set('mode', 'edit');
    // TODO: Not sure what spa=0 does, at least bitbucket.org doesn't support it
    // but this is taken over from the initial implementation.
    editUrl.searchParams.set('spa', '0');
    editUrl.searchParams.set('at', urlData.ref);
    return editUrl.toString();
  }
}
